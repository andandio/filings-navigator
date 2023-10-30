import * as React from 'react';
import DashboardContainer from './DashboardContainer';
import DashboardTable from "./DashboardTable";
import Summary from "./Summary";

const Dashboard = () => {
  return (
    <DashboardContainer title={"Filings Navigator"} showLink={false}>
      <Summary />
      <DashboardTable/>
    </DashboardContainer>
  )
}

export default Dashboard
