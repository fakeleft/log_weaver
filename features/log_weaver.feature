Feature: run command line app; weave log files by timestamp
  As a log weaver user
  I want to weave log files together into a single file
  So troubleshooting doesn't drive me insane

  Scenario: app has banner stating options and required arguments
    When I get help for "log_weaver"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
    And the banner should document that this app's arguments are:
      | file1            | which is required |
      | file2            | which is required |
      | additional_files | which is optional |


  Scenario: Handle non-existent first file
    Given no file named "file1"
    And an empty file named "file2"
    When I run `log_weaver file1 file2`
    Then the exit status should not be 0
    And the stderr should contain "File 'file1' does not exist!"


