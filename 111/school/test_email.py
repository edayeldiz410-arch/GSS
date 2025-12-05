import smtplib
from email.message import EmailMessage

host = 'smtp.gmail.com'
port = 587
user = 'geniesysteme.school@gmail.com'
pwd = 'tjuftmfolltmaxqi'  # si vous utilisez le même mot de passe

msg = EmailMessage()
msg['Subject'] = 'Test SMTP'
msg['From'] = user
msg['To'] = 'vadire17@gmail.com'
msg.set_content('Test depuis le serveur')

s = smtplib.SMTP(host, port, timeout=10)
s.set_debuglevel(1)
s.ehlo()
s.starttls()
s.login(user, pwd)
s.send_message(msg)
s.quit()
print('OK_SENT')
