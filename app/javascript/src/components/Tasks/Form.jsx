import React from "react";

import { Input, Button } from "components/commons";

const Form = ({ type = "create", title, setTitle, loading, handleSubmit }) => {
  return (
    <form className="mb-4 w-full space-y-2" onSubmit={handleSubmit}>
      <Input
        label="Title"
        placeholder="Todo Title (Max 50 Characters Allowed)"
        value={title}
        onChange={e => setTitle(e.target.value.slice(0, 50))}
      />
      <Button
        type="submit"
        buttonText={type === "create" ? "Create Task" : "Update Task"}
        loading={loading}
      />
    </form>
  );
};

export default Form;