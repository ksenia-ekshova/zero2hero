//Aggregator хранит конфигурацию актива и все цены, принимает цены от контракта Transmitter 
//и проверяет, что получает цены именно от него, есть возможность заменить трансмиттер


interface IAggregator {
    function digits() external view returns(uint8 _digits);
    function name() external view returns(string memory _name);

    function getLastPrice() external view returns(uint roundId, uint timestamp, uint price);
    function getHistoryPrice(uint roundId) external view returns(uint timestamp, uint price);
}