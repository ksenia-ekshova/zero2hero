import hashlib

prefix = "zero2hero+"
nonce = 0
while True:
    message = prefix + str(nonce)
    hash_result = hashlib.sha256(message.encode()).hexdigest()
    if hash_result[:5] == "00000":
        print("Входное значение:", message)
        print("Хеш:", hash_result)
        break
    nonce += 1

#входное значение: zero2hero+18414
#полученный хэш: 000007f453946a7f1d68f52244d7acbfaf9f7031246508fd8dd6f2b181706b8f
