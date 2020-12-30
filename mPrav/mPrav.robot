*** Settings ***
Suite Setup
Test Teardown     Close Browser
Variables         locators.py    # elements locators file
Library           Screenshot
Library           Collections
Library           String
Library           SeleniumLibrary

*** Variables ***
${url}            https://mozgoprav.com.ua/
${timeout}        3

*** Test Cases ***
1
    Comment    Setup chrome to run in full screen without warnings
    chrome_setup    ${url}
    wait_n_click    xpath    ${book_button}
    Select Frame    ${book_frame}
    Sleep    5
    Wait Until Element Is Visible    xpath=${book_type}    timeout=${timeout}
    Click Element    xpath=${book_type}
    Comment    Sleep    3
    Comment    wait_n_click    xpath    ${book_type}
    Comment    wait_n_click    xpath    ${personal_cons_chkbox}
    Comment    wait_n_click    xpath    ${next_button}
    Comment    ${date_button}=    set_calendar_button    28
    Comment    wait_n_click    xpath    ${date_button}
    Unselect Frame

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
    Wait Until Element Is Visible    ${type}=${locator}
    Click Element    ${type}=${locator}
    Sleep    3

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

set_calendar_button
    [Arguments]    ${date}
    ${link_tmp}=    Set Variable    //button[contains(text(),"${date}")]
    Return From Keyword    ${link_tmp}
