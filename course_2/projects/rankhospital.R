rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  data <- NULL
  data <- read.csv("course_2/data/outcome-of-care-measures.csv", colClasses = "character")

  ## Check that state and outcome are valid
  is_outcome <- outcome %in% c("heart attack", "heart failure", "pneumonia")
  if (!is_outcome) {
    stop("invalid outcome")
  }
  is_state <- state %in% unique(data[["State"]])
  if (!is_state) {
    stop("invalid state")
  }

  ## heart attack
  if (outcome == "heart attack") {
    col_num <- 11
  }
  ## heart failure
  if (outcome == "heart failure") {
    col_num <- 17
  }
  ## pneumonia
  if (outcome == "pneumonia") {
    col_num <- 23
  }

  data <- subset(data, data["State"] == state)
  data <- data[order( data[,2] ),]

  ## Return hospital name in that state with the given rank
  ## 30-day death rate

  data <- data[, c(2, col_num)]
  data <- subset(data, data[, 2] != "Not Available")

  data[, 2] <- as.numeric(data[, 2] )
  data <- data[order( data[, 2] ),]

  data$Rank <- NA
  data$Rank <- rank(data[, 2], ties.method= "first")

  if (num == "best") {
    num <- 1
  } else if (num == "worst") {
    num <- nrow(data)
  }

  if (num > nrow(data)) {
    best <- NA
  }

  best <- data[num,"Hospital.Name"]
  best
}

state <- "TX"
outcome <- "heart failure"
num <- 4

rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)
rankhospital("WY", "pneumonia", "worst")
rankhospital("WV", "pneumonia", "worst")
rankhospital("WI", "pneumonia", "worst")

rankhospital("NC", "heart attack", "worst")
rankhospital("WA", "heart attack", 7)
rankhospital("TX", "pneumonia", 10)
rankhospital("NY", "heart attack", 7)