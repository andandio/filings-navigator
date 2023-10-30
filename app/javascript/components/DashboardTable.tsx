import * as React from "react";
import { ReactElement, useState } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Button,
} from "@mui/material";
import { formatHeaderString, formatCell } from "../utils";
import NavigatorTableContainer from "./NavigatorTableContainer";
const axios = require("axios").default;

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
  tableContainer: {
    borderTopRightRadius: "0px",
    borderTopLeftRadius: "0px",
  },
  tableHeader: {
    fontWeight: "600",
    "&:not(:first-of-type)": {
      minWidth: "100px",
    },
  },
  tableData: {
    "&:not(:first-of-type)": {},
  },
  tableRow: {
    cursor: "pointer",
    "&:last-child td, &:last-child th": {
      border: 0,
    },
  },
};

type responseData = {
  [key: string]: any;
};

const DashboardTable = () => {
  const [resource, setResource] = useState<string>("");
  const [tableHeaders, setTableHeaders] = useState<string[]>([]);
  const [displayData, setDisplayData] = useState<responseData[]>([]);

  const queryApi = (resource: string, idParam?: string) => {
    setResource(resource);
    const params = idParam ? { params: { resource_id: idParam } } : {};
    const queryString = `/api/${resource}`;

    axios
      .get(queryString, params)
      .then(function (response) {
        populateTable(response.data);
      })
      .catch(function (error) {
        alert("Something went wrong. Please try again.");
        console.log(error);
      });
  };

  const populateTable = (tableData: responseData) => {
    const data = tableData.data;
    const headers = Object.keys(tableData.data[0]).filter((d)=> d !== "filing_years");
    setTableHeaders(headers);
    setDisplayData(data);
  };

  const buttons: ReactElement[] = [
    <Button variant="text" onClick={() => queryApi("filers")} key="filers">
      FILERS
    </Button>,
    <Button variant="text" onClick={() => queryApi("filings")} key="filings">
      FILINGS
    </Button>,
    <Button variant="text" onClick={() => queryApi("awards")} key="awards">
      AWARDS
    </Button>,
  ];

  const instructions = () => {
    if (resource === "filers") {
      return "Click a row to explore a filer";
    }
    if (resource === "filings") {
      return "Click a row to filter filings by filer";
    }
    return "";
  };

  const handleRowOnClick = (id: string) => {
    if (resource === "filings") {
      return queryApi("filings", id);
    } else if (resource === "filers") {
      return (window.location.href = `/filers/${id}`);
    }
  };

  return (
    <NavigatorTableContainer buttons={buttons} instructions={instructions()}>
      <Table aria-label={"data-table"}>
        <TableHead>
          <TableRow>
            {tableHeaders.map((header) => {
              return (
                <TableCell sx={styles.tableHeader} key={`header-${header}`}>
                  {formatHeaderString(header)}
                </TableCell>
              );
            })}
          </TableRow>
        </TableHead>
        <TableBody>
          {displayData.map((row, i) => (
            <TableRow
              key={`row-${row.id}-${i}`}
              sx={styles.tableRow}
              onClick={() => handleRowOnClick(row.id)}
            >
              {Object.keys(row).map((key) => {
                return (
                  <TableCell
                    key={`${key}-cell`}
                    component="td"
                    scope="row"
                    sx={styles.tableData}
                  >
                    <span>{formatCell(row[key])}</span>
                  </TableCell>
                );
              })}
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </NavigatorTableContainer>
  );
};

export default DashboardTable;
