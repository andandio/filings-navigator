import * as React from "react";
import { ReactElement } from "react";
import { useState, useEffect } from "react";
import DashboardContainer from "./DashboardContainer";
import NavigatorTableContainer from "./NavigatorTableContainer";
import {
  Button,
  Card,
  CardContent,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow
} from "@mui/material";
import { 
  formatCell,
  formatHeaderString 
} from "../utils";
const axios = require('axios').default;

type filerObj = {
  filing_years: string[];
  id: number,
  ein: string,
  name: string,
  address: string,
  city: string,
  state: string,
  zip: string
}

type responseData = {
  [key:string]: any
}

const styles = {
  tableHeader: {
    fontWeight: "600",
    "&:not(:first-of-type)": {
        minWidth: "100px"   
    }
  },
  tableContainer: {
    borderTopRightRadius: "0px",
    borderTopLeftRadius: "0px",
  },
  filerName: {
    borderBottom: "8px",
    fontSize: "1.5rem"
  },
  filerData: {
    marginBottom: "4px"
  }
}

const Filer = () => {
    const [filer, setFiler] = useState<filerObj | null>(null);
    const [awardData, setAwardData] = useState<responseData | null>(null);
    const [tableHeaders, setTableHeaders] = useState<string[] | null>(null);
    
    useEffect(() => {
      const path = window.location.pathname;
      const filerUrl = path.split("/")
      const filerId = filerUrl[filerUrl.length-1]
      queryFiler(filerId);
    },[])

    const queryFiler = (id:string) => {
      const queryString = `/api/filers/${id}`;
      axios.get(queryString)
      .then(function (response) {
        // console.log(response.data)
        setFiler(response.data.data)
      })
      .catch(function (error) {
        alert("Something went wrong. Please try again.")
        console.log(error);
      })
    }

    const queryAwardsByYear = (taxYear:string) => {
        const queryString = '/api/awards';
        axios.get(queryString, {params: {year: taxYear, filer_id: filer.id}})
        .then(function (response) {
        //   console.log(response.data)
          setAwardData(response.data.data)
          setTableHeaders(Object.keys(response.data.data[0]))
        })
        .catch(function (error) {
          alert("Something went wrong. Please try again.")
          console.log(error);
        })
    }
   
    const buttons:ReactElement[] = filer?.filing_years?.map((year) => {
      const yearDate = new Date(year)
      return (
        <Button variant="text" onClick={() => queryAwardsByYear(year)} key={year}>{yearDate.getFullYear()}</Button>
      )
    })

    return (
      <DashboardContainer title={"Filer Information"} showLink={true}>
        { filer && 
          <Card sx={{ mb: 1.5 }}>
            <CardContent>
              <Typography component="h2" sx={styles.filerName}>
                {filer.name}
              </Typography>
              <Typography component="h3" sx={styles.filerData}>
                {filer.ein}
              </Typography>
              <Typography component="h3" sx={styles.filerData}>
                {filer.address}
              </Typography>
              <Typography component="h3" sx={styles.filerData}>
                {`${filer.city}, ${filer.state} ${filer.zip}`}
              </Typography>
            </CardContent>
          </Card>
        }
        <NavigatorTableContainer buttons={buttons || []}>
          <Table aria-label={"data-table"}>
            <TableHead>
                <TableRow>
                {tableHeaders?.map((header) => {
                    return (
                    <TableCell sx={styles.tableHeader} key={`header-${header}`}>{formatHeaderString(header)}</TableCell>
                    )
                })}
                </TableRow>
            </TableHead>
            <TableBody>
                {awardData?.map((row, i) => (
                    <TableRow
                        key={`row-${row.id}-${i}`}
                        sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                    >
                        {Object.keys(row).map((key) => {
                        return (
                            <TableCell key={`${key}-cell`} component="td" scope="row">
                            <span>
                                {formatCell(row[key])}
                            </span>
                            </TableCell>
                        )
                        })}
                    </TableRow>
                ))}
                {!awardData && buttons && buttons.length === 0 && 
                  <TableRow>
                      <TableCell>
                        <Typography sx={{padding: "1rem"}}>No grantmaker data available.</Typography>
                      </TableCell>
                  </TableRow>
                }
            </TableBody>
          </Table>
        </NavigatorTableContainer>   
      </DashboardContainer>
    )
  }
  
  export default Filer