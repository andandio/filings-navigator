import * as React from "react";
import { ReactElement, useState } from "react";
import { Box, TableContainer, Paper, Card, Typography } from "@mui/material";

const styles = {
  buttons: {
    display: "flex",
    gap: "0.5rem",
    borderBottomRightRadius: "0px",
    borderBottomLeftRadius: "0px",
    "& button": {
      height: "54px",
      padding: "8px",
      color: "rgb(242, 111, 99)",
      fontFamily: "Raleway, sans-serif",
      "&:hover": {
        color: "white",
        background: "rgb(242, 111, 99)",
      },
    },
  },
  tableCard: {
    padding: "1.5rem",
    minHeight: "44px",
  },
  tableContainer: {
    borderTopRightRadius: "0px",
    borderTopLeftRadius: "0px",
  },
};

type NavigatorTableContainerProps = {
  buttons?: ReactElement[];
  children: ReactElement;
  instructions?: string;
};

const NavigatorTableContainer = ({
  buttons,
  children,
  instructions,
}: NavigatorTableContainerProps) => {
  return (
    <>
      <Card sx={styles.tableCard}>
        <Box sx={styles.buttons}>{buttons.map((b) => b)}</Box>
        <Typography component="p" sx={{ paddingLeft: "8px" }}>
          {instructions}
        </Typography>
      </Card>
      <TableContainer sx={styles.tableContainer} component={Paper}>
        {children}
      </TableContainer>
    </>
  );
};

export default NavigatorTableContainer;
