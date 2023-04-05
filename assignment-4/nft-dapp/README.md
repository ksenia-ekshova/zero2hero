# NFT-коллекция Pixel Cats

# Реализованные подзадачи
- создана собственная NFT коллекция с уникальными изображениями, с использованием библиотек OpenZeppelin
- ссылка на opensea коллекции (заминчены 4 NFT из 5) https://testnets.opensea.io/collection/pixelcats-6 
- ссылка на транзакцию https://testnet.bscscan.com/token/0xB1E341E2BBbc234DDb0CF1d666841b491b959016
- для второго задания коллекция была обновлена (изменены названия коллекции и NFT), контракт задеплоен повторно https://testnets.opensea.io/collection/pixel-cats
- написаны тесты, coverage report приведен ниже
- сгенерирован gas report (см. ниже)
- в файле `utility` потенциальное ютилити NFT коллекции
- в папке `scripts` находятся скрипты для деплоя
- в папке `ipfs` находятся файлы которые были размещены в IPFS (5 NFT)

# Coverage report
```bash
   NFT
    ✔ Should return the correct name and symbol
    ✔ Should have a total supply of 0 at deployment
    ✔ Should mint an NFT to the owner
    ✔ Should not mint an NFT if the cost is not paid
    ✔ Should not mint more than the maximum supply (71ms)


  5 passing (2s)
```

# Gas report

```bash
·------------------------------|----------------------------|-------------|-----------------------------·
|     Solc version: 0.8.18     ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
·······························|····························|·············|······························
|  Methods                                                                                              │
·············|·················|··············|·············|·············|···············|··············
|  Contract  ·  Method         ·  Min         ·  Max        ·  Avg        ·  # calls      ·  usd (avg)  │
·············|·················|··············|·············|·············|···············|··············
|  NFT       ·  changeBaseURI  ·           -  ·          -  ·      33245  ·            2  ·          -  │
·············|·················|··············|·············|·············|···············|··············
|  NFT       ·  safeMint       ·      106014  ·     151414  ·     136281  ·            6  ·          -  │
·············|·················|··············|·············|·············|···············|··············
|  Deployments                 ·                                          ·  % of limit   ·             │
·······························|··············|·············|·············|···············|··············
|  NFT                         ·           -  ·          -  ·    3365427  ·       11.2 %  ·          -  │
·------------------------------|--------------|-------------|-------------|---------------|-------------·
```

# Команды для работы с проектом

# Необходимо указать в файле .env (см. .env.example)

BNBT_RPC_URL
BNBT_PRIVATE_KEY
ETHERSCAN_API_KEY

## Локальный деплой
```console
npx hardhat node
npx hardhat run scripts/deploy.js
```

## Компиляция
```console
npx hardhat clean && npx hardhat compile
```

## Запуск тестов с генерацией gas report, проверка покрытия кода тестами
```console
npx hardhat test
npx hardhat coverage
```

## Деплой (и минт внутри)
```console
npx hardhat run scripts/deploy.js --network bnbtestnet
```
