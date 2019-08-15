*** Settings ***
Suite Setup
Library           Selenium2Library
Variables         locators.py    # elements locators file
Library           Screenshot
Library           Collections
Library           String

*** Variables ***
${login}          WHITA_jiwanski
${password}       GranadaWH07
${bet_amount}     0.05

*** Test Cases ***
test1
    [Documentation]    *Bet check test*
    ...
    ...    - Navigate to http://sports.williamhill.com/betting/en-gb
    ...    - Navigate to a Premiership football event
    ...    - Select event and place a £0.05 bet for the home team to ‘Win’
    ...    - Place bet and assert the odds and returns offered
    ...    - Parameterise the betslip stake so any monetary value can be entered
    Comment    Set test url
    ${url}=    Set Variable    http://sports.williamhill.com/betting/en-gb/
    Comment    Setup chrome to run in full screen without warnings
    chrome_setup    ${url}
    Comment    Open login dialog
    wait_n_click    id    ${accountTabButton}
    Comment    Input credentials
    wait_n_input    id    ${login_input}    ${login}
    wait_n_input    id    ${password_input}    ${password}
    Comment    Submit login
    wait_n_click    xpath    ${log_sbmt_btn}
    Comment    Check that login happened by verifiyng a "Deposit" button
    check_element_is_present    xpath    ${deposit_btn}
    Comment    Open Football section
    wait_n_click    xpath    ${footbal_section}
    Comment    Open competitions section
    wait_n_click    xpath    ${competite_section}
    Comment    Select "Home" in first row of Premeire League section
    wait_n_click    xpath    ${win_home_1st_row}
    Comment    Input bet amount
    wait_n_input    xpath    ${bet_input}    ${bet_amount}
    Comment    Verification of odds
    check_element_is_present    xpath    ${odds_element}
    Comment    Verification of returns
    check_element_is_present    xpath    ${returns_1}
    check_element_is_present    xpath    ${returns_2}
    [Teardown]    Close Browser

test2
    [Documentation]    *Kalamba test task*
    ...
    ...    - Navigate to specified URL
    ...    - Verify that page contains text "Your full name"
    ...    - Verify that page do not contains text "Your sfull"
    Comment    Set test url
    ${url}=    Set Variable    http://enterprise.github.com/contact
    Comment    Setup chrome to run in full screen without warnings
    chrome_setup    ${url}
    Comment    Check presence
    ${text_to_search}=    Generate Random String    10    [NUMBERS]abcdef
    log    Random string is: ${text_to_search}
    Page Should Contain    ${text_to_search}
    Page Should Not Contain    Your sfull
    [Teardown]    Close Browser

*** Keywords ***
wait_n_click
    [Arguments]    ${type}    ${locator}
    Wait Until Element Is Visible    ${type}=${locator}    timeout=3
    Wait Until Element Is Enabled    ${type}=${locator}    timeout=3
    Click Element    ${type}=${locator}    timeout=3

wait_n_input
    [Arguments]    ${type}    ${locator}    ${text}
    Wait Until Element Is Visible    ${type}=${locator}    timeout=3
    Clear Element Text    ${type}=${locator}
    Input Text    ${type}=${locator}    ${text}

chrome_setup
    [Arguments]    ${url}
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${chrome_options}    add_argument    --start-maximized
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --enable-automation
    Call Method    ${chrome_options}    add_argument    --disable-infobars
    Create Webdriver    Chrome    my_alias    chrome_options=${chrome_options}
    Go To    ${url}
    Set Selenium Speed    0.3

check_element_is_present
    [Arguments]    ${type}    ${locator}
    sleep    1
    Wait Until Element Is Visible    ${type}=${locator}    timeout=3
    Element Should Be Visible    ${type}=${locator}
