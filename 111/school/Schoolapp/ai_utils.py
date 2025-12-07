import os
import json
import tempfile
import urllib.request
import base64
from django.conf import settings

def extract_text_from_file(path):
    """Try to extract readable text from a file.

    - If PyMuPDF (fitz) is available and file is PDF, use it.
    - Else if Pillow + pytesseract are available, try OCR on images.
    Returns extracted text (possibly empty) and a short error string (or None).
    """
    text = ""
    err = None
    try:
        # try PDF via PyMuPDF
        try:
            import fitz  # PyMuPDF
            if path.lower().endswith('.pdf'):
                doc = fitz.open(path)
                parts = []
                for page in doc:
                    parts.append(page.get_text())
                text = "\n".join(parts)
                return text, None
        except Exception:
            # not a PDF or fitz not installed
            pass

        # try image OCR via pytesseract
        try:
            from PIL import Image
            import pytesseract
            # Open the image and OCR
            img = Image.open(path)
            text = pytesseract.image_to_string(img)
            return text, None
        except Exception:
            pass

        # fallback: try reading file as text
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                text = f.read()
                return text, None
        except Exception as e:
            err = str(e)
    except Exception as e:
        err = str(e)
    return text or "", err


def parse_text_with_openrouter(text):
    """Call OpenRouter (via OpenAI client) to summarize/extract a concise description.

    Reads API key from environment variable OPENROUTER_API_KEY or Django settings
    attribute OPENROUTER_API_KEY. Returns the string to store in description.
    If any error occurs or the env var is missing, returns an empty string.
    """
    if not text:
        return ""

        

    # get API key
    api_key = os.environ.get('OPENROUTER_API_KEY') or getattr(settings, 'OPENROUTER_API_KEY', None)
    if not api_key:
        return ""

    try:
        # Build strict prompt and messages
        base_doc = text[:3000]
        system_msg = (
            "Vous êtes un assistant utile. Répondez UNIQUEMENT en FRANÇAIS par une seule phrase concise. "
            "Ne donnez pas votre raisonnement, ne fournissez pas d'étapes ou de balises. Retournez uniquement le texte final, une phrase."
        )
        user_msg = (
            "Résumez le document ci-dessous en une courte description de la dépense (vendeur, montant si présent, date si présent, but). "
            "Réponse: UNE SEULE PHRASE en français.\n\nDocument:\n" + base_doc
        )

        messages = [
            {"role": "system", "content": system_msg},
            {"role": "user", "content": user_msg},
        ]

        def _call_client(messages, max_tokens=500, temperature=0.0):
            # try client then urllib; return string (possibly empty)
            try:
                from openai import OpenAI
                client = OpenAI(base_url="https://openrouter.ai/api/v1", api_key=api_key)
                resp = client.chat.completions.create(
                    model="minimax/minimax-m2:free",
                    messages=messages,
                    max_tokens=max_tokens,
                    temperature=temperature,
                )
                try:
                    return resp.choices[0].message["content"].strip()
                except Exception:
                    try:
                        return resp['choices'][0]['message']['content'].strip()
                    except Exception:
                        return str(resp)
            except Exception:
                # fallback to urllib
                try:
                    import urllib.request
                    url = 'https://openrouter.ai/api/v1/chat/completions'
                    body = {'model': 'minimax/minimax-m2:free', 'messages': messages, 'max_tokens': max_tokens, 'temperature': temperature}
                    data = json.dumps(body).encode('utf-8')
                    headers = {'Content-Type': 'application/json', 'Authorization': f'Bearer {api_key}'}
                    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
                    with urllib.request.urlopen(req, timeout=30) as resp:
                        resp_text = resp.read().decode('utf-8')
                    parsed = json.loads(resp_text)
                    try:
                        return parsed['choices'][0]['message']['content'].strip()
                    except Exception:
                        try:
                            return parsed['choices'][0]['text'].strip()
                        except Exception:
                            return str(parsed)
                except Exception:
                    return ""

        # First attempt: strict prompt, deterministic
        content = _call_client(messages, max_tokens=500, temperature=0.0)
        if content and content.strip():
            return content.strip()

        # Second attempt: even simpler instruction (short fallback)
        try:
            messages2 = [
                {"role": "system", "content": system_msg},
                {"role": "user", "content": "En une seule phrase en français, que résume ce document :\n\n" + base_doc[:1200]},
            ]
            content2 = _call_client(messages2, max_tokens=200, temperature=0.0)
            return (content2 or "").strip()
        except Exception:
            return ""
    except Exception:
        return ""


def parse_text_with_gemini(text):
    """Call Google Generative Models API (Gemini/text-bison/chat-style) to extract a concise
    French one-line description from the provided text.

    The function reads the API key from environment variable GOOGLE_API_KEY or Django
    settings.GOOGLE_API_KEY. It does NOT accept a raw key argument to avoid accidental
    key leaks in code. If the key is missing or any error occurs, returns an empty string.
    """
    if not text:
        return ""

    api_key = os.environ.get('GOOGLE_API_KEY') or getattr(settings, 'GOOGLE_API_KEY', None)
    if not api_key:
        return ""

    # model name can be overridden in settings if needed
    model = getattr(settings, 'GOOGLE_MODEL', 'models/text-bison-001')

    # Build a short prompt (avoid sending massive OCR dumps; use first N chars)
    base_doc = text[:3000]
    system_msg = (
        "Vous êtes un assistant utile. Répondez UNIQUEMENT en FRANÇAIS par une seule phrase concise. "
        "Ne donnez pas votre raisonnement, ne fournissez pas d'étapes ou de balises. Retournez uniquement le texte final, une phrase."
    )
    user_msg = (
        "En une seule phrase en français, résumez la dépense/document ci-dessous (vendeur, montant si présent, date si présent, objectif) :\n\n" + base_doc
    )

    body = {
        # Chat-style prompt; the exact schema can vary between API versions. This structure
        # matches the Generative Models API pattern where prompt.messages is supported.
        "prompt": {
            "messages": [
                {"author": "system", "content": [{"type": "text", "text": system_msg}]},
                {"author": "user", "content": [{"type": "text", "text": user_msg}]},
            ]
        },
        "temperature": 0.0,
        "maxOutputTokens": 256,
    }

    try:
        import urllib.request
        url = f'https://generativemodels.googleapis.com/v1/{model}:generate?key={api_key}'
        data = json.dumps(body).encode('utf-8')
        headers = {'Content-Type': 'application/json'}
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=30) as resp:
            resp_text = resp.read().decode('utf-8')
        parsed = json.loads(resp_text)

        # Try to extract a text candidate from common response shapes
        # Recent responses often include 'candidates' -> [{'content':[{'text': ...}]}]
        try:
            cands = parsed.get('candidates') or parsed.get('candidates', [])
            if cands and isinstance(cands, list):
                first = cands[0]
                # content may be a list of blocks
                cont = first.get('content') if isinstance(first, dict) else None
                if cont and isinstance(cont, list):
                    parts = []
                    for block in cont:
                        if isinstance(block, dict) and 'text' in block:
                            parts.append(block['text'])
                        elif isinstance(block, str):
                            parts.append(block)
                    if parts:
                        return ' '.join(parts).strip()
        except Exception:
            pass

        # Fallbacks for other possible fields
        try:
            # some responses have 'output' or 'candidates'[0]['output']
            if 'output' in parsed:
                out = parsed['output']
                if isinstance(out, str) and out.strip():
                    return out.strip()
        except Exception:
            pass

        # Last resort: stringify the response
        return json.dumps(parsed)[:1000]
    except Exception:
        return ""


def parse_text_auto(text):
    """High-level helper: try Gemini first (if available), fall back to OpenRouter.
    Returns the parsed short description (string) or empty string on failure.
    """
    if not text:
        return ""
    # Try Gemini if configured
    gem = parse_text_with_gemini(text)
    if gem:
        return gem.strip()
    # Fallback to existing OpenRouter flow
    return parse_text_with_openrouter(text)


def parse_chat_with_gemini(user_message, context_text=None):
    """Make a conversational chat-style request to Google Generative Models API.

    Returns the assistant reply (string) or empty string on failure.
    """
    if not user_message and not context_text:
        return ""
    api_key = os.environ.get('GOOGLE_API_KEY') or getattr(settings, 'GOOGLE_API_KEY', None)
    if not api_key:
        return ""

    model = getattr(settings, 'GOOGLE_MODEL', 'models/text-bison-001')

    system_msg = (
        "Vous êtes un assistant conversationnel utile et poli. Répondez en FRANÇAIS de manière claire et concise. "
        "Ne fournissez pas votre raisonnement interne."
    )

    full_user = ''
    if context_text:
        # include a short context prefix
        ctx = (context_text[:3000] + '...') if len(context_text) > 3000 else context_text
        full_user = f"Contexte (pièce jointe résumé) :\n{ctx}\n\n"
    full_user += user_message

    body = {
        "prompt": {
            "messages": [
                {"author": "system", "content": [{"type": "text", "text": system_msg}]},
                {"author": "user", "content": [{"type": "text", "text": full_user}]},
            ]
        },
        "temperature": 0.2,
        "maxOutputTokens": 512,
    }

    try:
        import urllib.request
        url = f'https://generativemodels.googleapis.com/v1/{model}:generate?key={api_key}'
        data = json.dumps(body).encode('utf-8')
        headers = {'Content-Type': 'application/json'}
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=40) as resp:
            resp_text = resp.read().decode('utf-8')
        parsed = json.loads(resp_text)
        # Extract candidate text
        try:
            cands = parsed.get('candidates') or []
            if cands and isinstance(cands, list):
                first = cands[0]
                cont = first.get('content') if isinstance(first, dict) else None
                if cont and isinstance(cont, list):
                    parts = []
                    for block in cont:
                        if isinstance(block, dict) and 'text' in block:
                            parts.append(block['text'])
                        elif isinstance(block, str):
                            parts.append(block)
                    if parts:
                        return ' '.join(parts).strip()
        except Exception:
            pass

        # fallback to other fields
        try:
            if 'output' in parsed and isinstance(parsed['output'], str):
                return parsed['output'].strip()
        except Exception:
            pass

        return json.dumps(parsed)[:1000]
    except Exception:
        return ""


def parse_chat_auto(user_message, context_text=None):
    """High-level chat helper: tries Gemini chat, falls back to OpenRouter-like chat.

    Returns assistant reply string or empty string on failure.
    """
    if not user_message and not context_text:
        return ""
    # Try Gemini chat
    try:
        r = parse_chat_with_gemini(user_message, context_text=context_text)
        if r:
            return r.strip()
    except Exception:
        pass

    # Fallback: try OpenRouter chat completion using the OpenRouter API key
    openrouter_key = os.environ.get('OPENROUTER_API_KEY') or getattr(settings, 'OPENROUTER_API_KEY', None)
    if not openrouter_key:
        return ""

    system_msg = (
        "Vous êtes un assistant conversationnel utile et poli. Répondez en FRANÇAIS de manière claire et concise."
    )
    full_user = ''
    if context_text:
        full_user = f"Contexte (pièce jointe résumé) :\n{(context_text[:3000] + '...') if len(context_text)>3000 else context_text}\n\n"
    full_user += user_message

    messages = [
        {"role": "system", "content": system_msg},
        {"role": "user", "content": full_user},
    ]

    try:
        import urllib.request
        url = 'https://openrouter.ai/api/v1/chat/completions'
        body = {'model': 'minimax/minimax-m2:free', 'messages': messages, 'max_tokens': 512, 'temperature': 0.2}
        data = json.dumps(body).encode('utf-8')
        headers = {'Content-Type': 'application/json', 'Authorization': f'Bearer {openrouter_key}'}
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=40) as resp:
            resp_text = resp.read().decode('utf-8')
        parsed = json.loads(resp_text)
        try:
            return parsed['choices'][0]['message']['content'].strip()
        except Exception:
            try:
                return parsed['choices'][0]['text'].strip()
            except Exception:
                return ''
    except Exception:
        return ''


# ---------------------------------------------------------------------------
# Grok-specific helper (uses a hard-coded API key per user request)
# WARNING: This function embeds a literal API key as requested by the user.
# ---------------------------------------------------------------------------
GROK_API_KEY = "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"


def parse_chat_with_grok(user_message, context_text=None, images=None):
    """Call the OpenRouter endpoint using the Grok model (`x-ai/grok-4.1-fast`).

    This function uses the hard-coded `GROK_API_KEY` above (user requested).
    It returns a short assistant reply string or empty string on failure.
    """
    if not user_message and not context_text:
        return ""

    system_msg = (
        "Vous êtes G intelligence, un assistant très utile spécialisé pour extraire et remplir automatiquement "
        "les informations d'un bon/facture à partir d'un texte ou d'une image. Répondez en FRANÇAIS, soyez concis."
    )

    full_user = ''
    # If images provided, include a short base64 snippet hint so the model can analyze images
    if images and isinstance(images, list) and len(images) > 0:
        parts = []
        parts.append('Contexte: images jointes fournies. Le modèle doit analyser les images et répondre en conséquence.')
        for i, im in enumerate(images):
            name = im.get('name') or f'image_{i+1}'
            data_url = im.get('data_url') or ''
            snippet = data_url[:12000]
            parts.append(f'Image {i+1} ({name}) base64 (tronqué): {snippet}')
        full_user = '\n\n'.join(parts) + '\n\n'
    elif context_text:
        full_user = f"Contexte (pièce jointe résumé) :\n{(context_text[:3000] + '...') if len(context_text)>3000 else context_text}\n\n"
    full_user += user_message

    messages = [
        {"role": "system", "content": system_msg},
        {"role": "user", "content": full_user},
    ]

    try:
        url = 'https://openrouter.ai/api/v1/chat/completions'
        body = {'model': 'x-ai/grok-4.1-fast', 'messages': messages, 'max_tokens': 512, 'temperature': 0.2}
        data = json.dumps(body).encode('utf-8')
        headers = {'Content-Type': 'application/json', 'Authorization': f'Bearer {GROK_API_KEY}'}
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=40) as resp:
            resp_text = resp.read().decode('utf-8')
        parsed = json.loads(resp_text)
        try:
            return parsed['choices'][0]['message']['content'].strip()
        except Exception:
            try:
                return parsed['choices'][0]['text'].strip()
            except Exception:
                return ''
    except Exception:
        return ''


def parse_chat_with_grok_structured(user_message, context_text=None, images=None):
    """Ask Grok to extract structured fields from the message/context and return JSON.

    Returns a dict if parsing succeeds, otherwise None.
    Expected keys: type, montant, date, reference, remarque
    """
    if not user_message and not context_text:
        return None

    system_msg = (
        "Vous êtes G intelligence. À partir du message utilisateur et du contexte fourni (pièce jointe résumé) : "
        "extrayez les champs suivants si présents: type, montant (nombre, uniquement les chiffres), date (YYYY-MM-DD si possible), reference (texte), remarque (texte libre). "
        "Répondez STRICTEMENT par un objet JSON valide avec ces clés. Ne fournissez rien d'autre."
    )

    full_user = ''
    # Prefer images (raw) over OCR text if provided
    if images and isinstance(images, list) and len(images) > 0:
        # images is expected to be a list of dicts {name:..., data_url:...}
        parts = []
        parts.append('Contexte: images jointes fournies. Le modèle doit analyser les images et extraire les champs demandés.')
        for i, im in enumerate(images):
            name = im.get('name') or f'image_{i+1}'
            data_url = im.get('data_url') or ''
            # Truncate base64 payload to avoid sending enormous content; give model a hint with the start of the base64
            snippet = data_url[:12000]
            parts.append(f'Image {i+1} ({name}) base64 (tronqué): {snippet}')
        full_user = '\n\n'.join(parts) + '\n\n'
    elif context_text:
        full_user = f"Contexte (pièce jointe résumé) :\n{(context_text[:3000] + '...') if len(context_text)>3000 else context_text}\n\n"
    full_user += user_message

    messages = [
        {"role": "system", "content": system_msg},
        {"role": "user", "content": full_user},
    ]

    try:
        url = 'https://openrouter.ai/api/v1/chat/completions'
        body = {'model': 'x-ai/grok-4.1-fast', 'messages': messages, 'max_tokens': 300, 'temperature': 0.0}
        data = json.dumps(body).encode('utf-8')
        headers = {'Content-Type': 'application/json', 'Authorization': f'Bearer {GROK_API_KEY}'}
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=40) as resp:
            resp_text = resp.read().decode('utf-8')
        parsed = json.loads(resp_text)
        try:
            txt = parsed['choices'][0]['message']['content'].strip()
        except Exception:
            try:
                txt = parsed['choices'][0]['text'].strip()
            except Exception:
                txt = ''
        if not txt:
            return None
        # Try to parse JSON from the model text
        try:
            # sometimes model returns code fence; strip surrounding backticks
            cleaned = txt.strip()
            if cleaned.startswith('```') and cleaned.endswith('```'):
                # remove fences
                cleaned = '\n'.join(cleaned.split('\n')[1:-1]).strip()
            # find first { and last }
            start = cleaned.find('{')
            end = cleaned.rfind('}')
            if start != -1 and end != -1 and end > start:
                json_part = cleaned[start:end+1]
            else:
                json_part = cleaned
            obj = json.loads(json_part)
            if isinstance(obj, dict):
                return obj
        except Exception:
            return None
    except Exception:
        return None
    return None
