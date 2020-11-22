from os import path
from OpenSSL import crypto, SSL
from datetime import datetime, date

class Certificate():
    def checkCertificateExpiration(self):
        expired = False

        cert = crypto.load_certificate(crypto.FILETYPE_PEM, open('certificate/cacert.pem', 'rt').read())
        cert_date = datetime.strptime(cert.get_notAfter().decode('utf-8'),"%Y%m%d%H%M%SZ")
        today = date.today()
        current_date = today.strftime("%Y-%m-%d")

        if str(current_date) == str(cert_date).split(" ")[0]:
            expired = True
        return expired

    def genCertificate(self, KEY_FILE="certificate/private.pem", CERT_FILE="certificate/cacert.pem"):
        k = crypto.PKey()
        k.generate_key(crypto.TYPE_RSA, 4096)

        cert = crypto.X509()
        cert.get_subject().C = "UK"
        cert.get_subject().ST = "London"
        cert.get_subject().L = "London"
        cert.get_subject().O = "Development"
        cert.get_subject().CN = "www.google.com"
        cert.gmtime_adj_notBefore(0)
        cert.gmtime_adj_notAfter(31557600)
        cert.set_issuer(cert.get_subject())
        cert.set_pubkey(k)
        cert.sign(k, 'sha512')
        with open(CERT_FILE, "wt") as f:
            f.write(crypto.dump_certificate(crypto.FILETYPE_PEM, cert).decode("utf-8"))
        with open(KEY_FILE, "wt") as f:
            f.write(crypto.dump_privatekey(crypto.FILETYPE_PEM, k).decode("utf-8"))

    def checkCertPath(self):
        exist = False
        if (path.exists("certificate/cacert.pem") and path.exists("certificate/private.pem")):
            exist = True
        return exist
