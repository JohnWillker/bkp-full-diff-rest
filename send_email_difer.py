import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEBase import MIMEBase
from email import encoders

fromaddr = "email@dominio.com" #Quem irá enviar os emails
toaddr = "email@dominio.com" #Quem receberá os emails
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = "BACKUP ARQUIVOS"

body = "BACKUP COMPLETO - TIPO: DIFERENCIAL DIARIO"
msg.attach(MIMEText(body, 'plain'))

filename = "diferencial.log"
attachment = open("/backup/log/diferencial.log", "rb")

part = MIMEBase('application', 'octet-stream')
part.set_payload((attachment).read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', "attachment; filename= %s" % filename)

msg.attach(part)
server = smtplib.SMTP('smtp.dominio.com', 587) # servidor smtp do email que irá mandar
server.starttls()
server.login(fromaddr, "SENHA") #Senha do email que irá mandar o email
text = msg.as_string()
server.sendmail(fromaddr, toaddr, text)
server.quit()
