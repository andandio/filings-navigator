import * as React from "react";
import { ReactNode } from "react";
import { Typography, Box } from "@mui/material";

const styles = {
  header: {
    fontSize: "2em",
    marginBottom: "1rem",
    fontFamily: "Raleway, sans-serif",
    fontWeight: "700",
  },
  container: {
    padding: "8rem",
  },
  data: {
    background: "#F2F5F7",
    padding: "2rem",
    borderRadius: "1rem",
  },
  link: {
    color: "#64447C",
  },
};

type DashboardContainerProps = {
  children: ReactNode;
  title: string;
  showLink: boolean;
};

const DashboardContainer = ({
  children,
  title,
  showLink,
}: DashboardContainerProps) => {
  return (
    <Box sx={styles.container}>
      {showLink && (
        <Typography sx={styles.link} component="a" href="/">
          Back to dashboard
        </Typography>
      )}
      <Typography sx={styles.header} component="h1">
        {title}
      </Typography>
      <Box sx={styles.data}>{children}</Box>
    </Box>
  );
};

export default DashboardContainer;
