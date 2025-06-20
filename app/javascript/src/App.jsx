import React from "react";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import Dashboard from "components/Dashboard"
import CreateTask from "components/Tasks/Create";

const App = () => {
  return (
    <Router>
      <Switch>
        <Route exact path="/" render={() => <div>Home</div>} />
        <Route exact path="/tasks/create" component={CreateTask} />
        <Route exact path="/dashboard" component={Dashboard}/>
      </Switch>
    </Router>
  );
};

export default App;