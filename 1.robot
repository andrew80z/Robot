*** Settings ***
Library           DateTime

*** Test Cases ***
date
    [Documentation]    This is my test which prints start date and finish date
    ${my_dates}=    Create Start and Future timestamps    -25    days
    log    ${my_dates[0]}
    log    ${my_dates[1]}

*** Keywords ***
Create Start and Future timestamps
    [Arguments]    ${increment}    ${time_type}    ${format}=run'%d.%m.%Y %H:%M'
    [Documentation]    Keyword returns a list with two elements containing
    ...    [RunCurrent Date, Future Date]
    ...
    ...    Uses: *Get Current Date*, *Convert Date*, *Add Time To Date* Keywords
    ...
    ...
    ...    Arguments:
    ...    - *${increment}*: Number of days/minutes/hours to add.
    ...    Negative values accepted
    ...    - *${time}* : Time type. _'days', 'minutes', 'hours'_
    ...    - *result_format*: Format of the returned date.
    ${date}=    Get Current Date    local
    ${date1}=    Convert Date    ${date}    ${format}
    ${date2}=    Add Time To Date    ${date}    ${increment} ${time_type}    result_format=${format}
    ${dates}=    Create List    ${date1}    ${date2}
    Return From Keyword    ${dates}
