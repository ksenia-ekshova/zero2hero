import hashlib

prefix = "zero2hero+"
nonce = 0
while True:
    message = prefix + str(nonce)
    hash_result = hashlib.sha256(message.encode()).hexdigest()
    if hash_result[:2] == "00":
        print("Входное значение:", message)
        print("Хеш:", hash_result)
        break
    nonce += 1

#входное значение: zero2hero+201
#полученный хэш: 00a1a07842acda45fdae72a46bb1e4c479e25c019ea2d15476abfedcab3e1201
