import * as React from "react";
import { useEffect, useState } from "react";
import { Box, Card, Typography } from "@mui/material";
import { BarChart } from "@mui/x-charts";
const axios = require("axios").default;

const styles = {
  container: {
    padding: "2rem",
    ["@media (max-width:780px)"]: {
      padding: "1rem"
    }
  },
  visualization: {
    padding: "2rem",
    "& .MuiChartsAxis-tickLabel": {
      fontSize: "8px !important",
    },
    "& .MuiBarElement-root": {
      fill: "#FF6E61",
    },
  },
  visBox: {
    overflowX: "auto"
  }
};

const Summary = () => {
  const [totalAwardDollars, setTotalAwardDollars] = useState<number[]>([]);
  const [years, setYears] = useState<string[]>([]);

  useEffect(() => {
    axios
      .get("/api/awards/historical_snapshot")
      .then(function (response) {
        const data = response.data.data;
        const allYears = Object.keys(data).map((k) => {
          return k.split("-")[0];
        });
        setYears(allYears);
        const allSums = Object.values(data).map((sum) => parseFloat(sum));
        setTotalAwardDollars(allSums);
      })
      .catch(function (error) {
        console.log(error);
      });
  }, []);

  return (
    <Box sx={styles.container}>
      <Card sx={styles.visualization}>
        <Typography component="h2" sx={{ fontSize: "1.5rem" }}>
          Total Awards by Year
        </Typography>
        {totalAwardDollars.length && (
          <Box sx={styles.visBox}>
            <BarChart
              width={600}
              height={400}
              series={[{ data: totalAwardDollars, type: "bar" }]}
              xAxis={[{ scaleType: "band", data: years }]}
            ></BarChart>
          </Box>
        )}
      </Card>
    </Box>
  );
};

export default Summary;
