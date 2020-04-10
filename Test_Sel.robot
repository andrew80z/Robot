*** Settings ***
Suite Setup
Test Teardown     screenshot_on_fail
Library           Selenium2Library
Variables         locators.py    # elements locators file
Library           Screenshot
Library           Collections
Library           String

*** Variables ***
${login}          WHITA_jiwanski
${password}       GranadaWH07
${bet_amount}     0.05
${timeout}        10

*** Test Cases ***
test1
    [Documentation]    *Bet check test*
    ...
    ...    - Navigate to http://sports.williamhill.com/betting/en-gb
    ...    - Navigate to a Premiership football event
    ...    - Select event and place a £0.05 bet for the home team to ‘Win’
    ...    - Place bet and assert the odds and returns offered
    ...    - Parameterise the betslip stake so any monetary value can be entered
    Comment    Comment    Set test url
    Comment    ${url}=    Set Variable    http://sports.williamhill.com/betting/en-gb/
    Comment    Comment    Setup chrome to run in full screen without warnings
    Comment    chrome_setup    ${url}
    Comment    Comment    Open login dialog
    Comment    wait_n_click    id    ${accountTabButton}
    Comment    Comment    Input credentials
    Comment    wait_n_input    id    ${login_input}    ${login}
    Comment    wait_n_input    id    ${password_input}    ${password}
    Comment    Comment    Submit login
    Comment    wait_n_click    xpath    ${log_sbmt_btn}
    Comment    Comment    Check that login happened by verifiyng a "Deposit" button
    Comment    check_element_is_present    xpath    ${deposit_btn}
    Comment    Comment    Open Football section
    Comment    wait_n_click    xpath    ${footbal_section}
    Comment    Comment    Open competitions section
    Comment    wait_n_click    xpath    ${competite_section}
    Comment    Comment    Select "Home" in first row of Premeire League section
    Comment    wait_n_click    xpath    ${win_home_1st_row}
    Comment    Comment    Input bet amount
    Comment    wait_n_input    xpath    ${bet_input}    ${bet_amount}
    Comment    Comment    Verification of odds
    Comment    check_element_is_present    xpath    ${odds_element}
    Comment    Comment    Verification of returns
    Comment    check_element_is_present    xpath    ${returns_1}
    Comment    check_element_is_present    xpath    ${returns_2}
    chrome_setup    https://github.com/SeleniumHQ/selenium/blob/master/py/selenium/webdriver/common/keys.py
    Press Keys    xpath=//body    \ue010
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

test3
    [Documentation]    *Kalamba test task*
    ...
    ...    - Navigate to specified URL
    ...    - Verify that page contains text "Your full name"
    ...    - Verify that page do not contains text "Your sfull"
    Comment    Set test url
    ${url}=    Set Variable    https://www.jquery-az.com/bootstrap4/demo.php?ex=79.0_1
    Comment    Setup chrome to run in full screen and start
    chrome_setup    ${url}
    wait_n_click    xpath    ${option_locator}
    select_element_from_dropdown    ${option_locator}    options    Bottom-Dollar Marketse
    [Teardown]    Close Browser

*** Keywords ***
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

firefox_setup
    [Arguments]    ${url}
    Open Browser    browser=firefox
    Go To    ${url}

wait_n_click
    [Arguments]    ${type}    ${locator}
    Wait Until Element Is Visible    ${type}=${locator}    timeout=${timeout}
    Clear Element Text    ${type}=${locator}
    Click Element    ${type}=${locator}

wait_n_input
    [Arguments]    ${type}    ${locator}    ${text}
    Wait Until Element Is Visible    ${type}=${locator}    timeout=${timeout}
    Clear Element Text    ${type}=${locator}
    Input Text    ${type}=${locator}    ${text}

check_element_is_present
    [Arguments]    ${type}    ${locator}
    sleep    1
    Wait Until Element Is Visible    ${type}=${locator}    timeout=${timeout}
    Element Should Be Visible    ${type}=${locator}

select_element_from_dropdown
    [Arguments]    ${dd_locator}    ${option_tagname}    ${element_text}
    [Documentation]    CLick elemtn from dropdown list by element's name
    Wait Until Element Is Visible    ${dd_locator}    timeout=${timeout}
    Wait Until Element Is Enabled    ${dd_locator}    timeout=${timeout}
    wait_n_click    xpath    ${dd_locator}
    ${option_element}=    ${dd_locator}/ ${element_text}
    wait_n_click    xpath    ${option_element}
    Sleep    10

check_element_is_active
    [Arguments]    ${type}    ${locator}
    sleep    1
    Wait Until Element Is Visible    ${type}=${locator}    timeout=${timeout}
    Element Should Be Visible    ${type}=${locator}
    Wait For Condition

screenshot_on_fail
    Run Keyword If Test Failed    Capture Page Screenshot
