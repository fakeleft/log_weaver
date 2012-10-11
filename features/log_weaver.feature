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

  Scenario: Handle non-existent second file
    Given an empty file named "file1"
    And no file named "file2"
    When I run `log_weaver file1 file2`
    Then the exit status should not be 0
    And the stderr should contain "File 'file2' does not exist!"

  Scenario: 2 files where timestamps in file1 come before timestamps in file2
    Given a file named "file1" with:
    """
    2012-01-01 00:00:00.001 - line1
    2012-01-01 00:00:00.002 - line2
    """
    And a file named "file2" with:
    """
    2012-01-01 00:00:00.003 - line3
    2012-01-01 00:00:00.004 - line4
    """
    When I successfully run `log_weaver file1 file2`
    Then the output should match:
    """
    file1:2012-01-01 00:00:00.001 - line1
    file1:2012-01-01 00:00:00.002 - line2
    file2:2012-01-01 00:00:00.003 - line3
    file2:2012-01-01 00:00:00.004 - line4
    """

