import React, { useState, useEffect } from "react";

import { isNil, isEmpty, either } from "ramda";

import tasksApi from "apis/tasks";
import { PageLoader, PageTitle, Container } from "components/commons";
import Table from "components/Tasks/Table";

const Dashboard = () => {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchTasks = async () => {
    try {
      const {
        data: { tasks },
      } = await tasksApi.fetch();
      setTasks(tasks);
      setLoading(false);
    } catch (error) {
      console.log(error);
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  if (loading) {
    return (
      <div className="h-screen w-screen">
        <PageLoader />
      </div>
    );
  }

  if (either(isNil, isEmpty)(tasks)) {
    return (
      <Container>
        <h1 className="my-5 text-center text-xl leading-5">
          You have not created or been assigned any tasks 🥳
        </h1>
      </Container>
    );
  }

  return (
    <Container>
      <div className="flex flex-col gap-y-8">
        <PageTitle title="Todo list" />
        <Table data={tasks} />
      </div>
    </Container>
  );
};

export default Dashboard;