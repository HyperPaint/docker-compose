# ca.key
openssl genrsa -out "nginx-ca.key" 2048

# ca.csr
openssl req -new -key "nginx-ca.key" -out "nginx-ca.csr" -subj "/CN=self-signed-ca"

# ca.pem
openssl x509 -days 3600 -req -in "nginx-ca.csr" -key "nginx-ca.key" -out "nginx-ca.pem"

# server.key
openssl genrsa -out "nginx-server.key" 2048

# server.csr
openssl req -new -key "nginx-server.key" -out "nginx-server.csr" -subj "/CN=self-signed-server"

# server.pem
openssl x509 -days 3600 -req -in "nginx-server.csr" -CA "nginx-ca.pem" -CAkey "nginx-ca.key" -CAcreateserial -out "nginx-server.pem"

# nginx-self-signed.key
cat "nginx-server.key" > "nginx-self-signed.key"

# nginx-self-signed.pem
cat "nginx-server.pem" "nginx-ca.pem" > "nginx-self-signed.pem"
