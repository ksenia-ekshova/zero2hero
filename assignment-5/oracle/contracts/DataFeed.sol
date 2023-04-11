//DataFeed - хранит соответствие "код актива" - "контракт Aggregator" в виде mapp и позволяет обновлять этот список


interface IDataFeed {
    function activesTotal() external view returns(uint digits);
    function activeId(uint8 activeCode) external view returns(uint8 digits);
    function activeName() external view returns(string memory _name);

    function getLastPrice(uint8 activeCode) external view returns(uint roundId, uint timestamp, uint price);
    function getHistoryPrice(uint8 activeCode, uint roundId) external view returns(uint timestamp, uint price);
}