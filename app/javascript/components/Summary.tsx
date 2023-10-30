import * as React from 'react';
import {
  Box,
  Card,
  CardActions,
  CardContent,
  Button,
  Typography

} from '@mui/material';

const styles = {
  container: {
    padding: "8rem",
  },
}

const Summary = () => {
  return (
    <Box sx={styles.container}>
      <Card></Card>
      <Card></Card>
      <Card></Card>
    </Box>
  )
}

export default Summary
