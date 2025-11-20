

def findMostActiveContract(operations, timeWindow):
    currentTime = 20
    windowStart = currentTime - timeWindow

    # Har bir dogovor uchun operatsiyalar sonini hisoblash
    contractCounts = {}

    for operation in operations:
        if operation.timestamp >= windowStart:
            if operation.contractId not in contractCounts:
                contractCounts[operation.contractId] = 0
            contractCounts[operation.contractId] += 1

    # Eng ko'p operatsiyali dogovorni topish
    maxCount = 0
    mostActiveContract = None

    for contractId, count in contractCounts.items():
        if count > maxCount:
            maxCount = count
            mostActiveContract = contractId

    return mostActiveContract, maxCount

s = findMostActiveContract([12, 13, 14, 15, 16, 17, 18, 19, 20], 5)
print(s)