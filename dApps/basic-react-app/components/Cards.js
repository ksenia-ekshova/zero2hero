function Cards() {
  return (
    <>
      <Card name="Alice" job="Teacher" />
      <Card name="Bob" job="Developer" />
      <Card name="Karl" job="Admin" />
    </>
  );
}

function Card({ name, job }) {
  return (
    <>
      <h3>{name}</h3>
      <p>{job}</p>
      <br></br>
    </>
  );
}

export default Cards;
