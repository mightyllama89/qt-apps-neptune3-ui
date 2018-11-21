Feature: The launch bar is configurable

    The launch bar is highly configurable.
    Sorted in a natural way the first items are
    visible.

    In the grid it is possible by drag and drop to
    move the items and change the order


    Scenario: Open the grid

        Given main menu is open
         And  the launch bar is shown
         When the grid icon is tapped
         Then the grid should be 'opened'
         When the grid icon is tapped
         Then the grid should be 'closed'

    Scenario Outline: Change order of several launcher icons in launcher grid

         Given main menu is open
         And the launch bar is shown
        When the grid icon is tapped
         Then the grid should be 'opened'
         When grid item '<launcher apps>' is tabbed and move index '<up>' up and '<right>' right
         And the '<launcher apps>' app index has increased by '<increase>'
         And the grid icon is tapped

  Examples:
           | launcher apps |   up | right | increase |
           |      music    |  0   |   1   |    1     |
#             |      map      |  0   |   1   |    1     |
#             |      phone    |  0   |   1   |    1     |
#             |    vehicle    |  0   |   1   |    1     |
#             |    settings   |  0   |   1   |    1     |

  Scenario: Test if launcher order in launcher bar changes due to edits

      Given main menu is open
        And memorize visible launchers index
      When the grid icon is tapped
       And grid item 'vehicle' is tabbed and move index '0' up and '1' right
       And the grid icon is tapped
      Then visible launcher of 'vehicle' should have changed to index '1'
