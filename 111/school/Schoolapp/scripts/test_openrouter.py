#!/usr/bin/env python3
"""Small test script to verify OpenRouter/OpenAI connectivity.

Usage:
  # set your key (PowerShell example, DO NOT paste the key publicly)
  $env:OPENROUTER_API_KEY = 'sk-or-...'
  python Schoolapp/scripts/test_openrouter.py "Texte de test pour vérifier la clé"

The script prints the model response (or error) so you can confirm the key works.
"""
import os
import sys
import json

def main():
    api_key = os.environ.get('OPENROUTER_API_KEY')
    if not api_key:
        print('ERROR: OPENROUTER_API_KEY not set in environment. Set it and retry.')
        sys.exit(1)

    try:
        from openai import OpenAI
    except Exception as e:
        print('ERROR: openai package not installed. Install with: pip install openai')
        print('Exception:', e)
        sys.exit(2)

    client = OpenAI(base_url="https://openrouter.ai/api/v1", api_key=api_key)

    text = ' '.join(sys.argv[1:]) if len(sys.argv) > 1 else 'Test de connexion OpenRouter. Réponds en une phrase: la clé fonctionne.'

    messages = [
        {"role": "system", "content": "You are a helpful assistant that answers in French."},
        {"role": "user", "content": text},
    ]

    try:
        resp = client.chat.completions.create(
            model="minimax/minimax-m2:free",
            messages=messages,
            max_tokens=200,
        )
    except Exception as e:
        print('Request failed:', str(e))
        sys.exit(3)

    # extract content safely
    content = None
    try:
        content = resp.choices[0].message['content']
    except Exception:
        try:
            content = resp['choices'][0]['message']['content']
        except Exception:
            content = str(resp)

    print('\n=== MODEL RESPONSE ===\n')
    print(content)

if __name__ == '__main__':
    main()
