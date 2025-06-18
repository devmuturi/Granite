import React, { useState } from "react";
import { withRouter } from "react-router-dom"; // ✅ Needed to inject the `history` prop
import { Container, PageTitle } from "components/commons";
import Form from "./Form";
import tasksApi from "apis/tasks";

const Create = ({ history }) => {
  const [title, setTitle] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async event => {
    event.preventDefault();
    setLoading(true);

    try {
      await tasksApi.create({ title });
      setLoading(false);
      history.push("/dashboard");
    } catch (error) {
      console.error("Failed to create task:", error);
      setLoading(false);
    }
  };

  return (
    <Container>
      <div className="flex flex-col gap-y-8">
        <PageTitle title="Add new task" />
        <Form
          type="create"
          handleSubmit={handleSubmit}
          loading={loading}
          title={title}
          setTitle={setTitle}
        />
      </div>
    </Container>
  );
};

export default withRouter(Create);
