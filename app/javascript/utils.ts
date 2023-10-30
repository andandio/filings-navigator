export const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleString("default", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
};

export const formatMoney = (moneyString: string) => {
  const formatting_options = {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 2,
  };
  const moneyFormat = new Intl.NumberFormat("en-US", formatting_options);
  return moneyFormat.format(parseFloat(moneyString));
};

export const formatHeaderString = (header: string) => {
  const formattedHeader = header.replace("_at", "").replace("_id", "");
  const spacedHeader = formattedHeader.split("_").join(" ");
  const capitalized =
    spacedHeader.charAt(0).toUpperCase() + spacedHeader.slice(1);
  return capitalized;
};

const isDate = (str: string) => {
  const dateReg = /^\d{4}-\d{2}-\d{2}T\d{2}:/;
  return !!str.match(dateReg);
};

const isDecimal = (val: string) => {
  const decimalReg = /\.\d+/;
  return !!val.match(decimalReg);
};

export const formatCell = (value: string | number | boolean) => {
  if (value === null) {
    return value;
  }

  if (typeof value === "object") {
    const key = Object.keys(value)[0];
    const data = value ? value[key] : "";
    return isDate(data) ? formatDate(data) : data;
  } else if (typeof value === "string" && isDate(value)) {
    return formatDate(value);
  } else if (typeof value === "string" && isDecimal(value)) {
    return formatMoney(value);
  } else {
    return value;
  }
};
