setwd("course_2/data")

# Method 2: data.table, which is way faster than Method 1
rankall <- function(outcome, num = "best"){
  # Read outcome data
  require(data.table)
  out_data <- fread("outcome-of-care-measures.csv")
  # Shorten variables names for look-up
  setnames(out_data, c(2, 7, 11, 17, 23),
           c("hospital", "state", "heart_attack", "heart_failure", "pneumonia"))
  # Check that num, state and outcome are valid
  if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
  if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
  else if (class(num) != "numeric" && num <= 0) stop("invalid num")
  outcome <- gsub(" ", "_", outcome) # For look-up
  # Select num, state and outcome, remove NA, arrange by state, outcome, hospital
  out_data <- out_data[, .SD, .SDcol=c("hospital", "state", outcome)]
  out_data[,outcome] <- out_data[, as.numeric(get(outcome))]
  out_data <- out_data[order(state, get(outcome), hospital, na.last = NA), 1:3]
  # Flow Control to return a data frame with the hospital names and the (abbreviated) state name
  if (num == "best"){
    out_data <- out_data[, .(hospital = head(hospital, 1)), by = state]
    return(setcolorder(out_data, rev(names(out_data))))
  }
  else if (num == "worst"){
    out_data <- out_data[, .(hospital = tail(hospital, 1)), by = state]
    return(setcolorder(out_data, rev(names(out_data))))
  }
  else {
    ref<-vapply(split(out_data, out_data$state), nrow, integer(1))
    out_data <- out_data[ , tail(head(.SD, num), 1)
      , by = state, .SDcols = c("hospital")]}
  # If num is larger than the number of hospitals in that state, return NA.
  idx <- num > ref
  out_data$hospital[idx] <- NA
  return(setcolorder(out_data, rev(names(out_data))))
}

# Testing
options(warn=-1)
options(message=-1)

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)

r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)
# [1] "CASTLE MEDICAL CENTER"
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)
# [1] "BERGEN REGIONAL MEDICAL CENTER"
r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)
# [1] "RENOWN SOUTH MEADOWS MEDICAL CENTER"