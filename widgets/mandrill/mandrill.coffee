class Dashing.Mandrill extends Dashing.Widget

  onData: (data) ->
    $(@node).removeClass("A B C D F")
    
    if data.data.reputation
      grade = switch
        when data.data.reputation >= 90 then "A"
        when data.data.reputation >= 80 then "B"
        when data.data.reputation >= 70 then "C"
        when data.data.reputation >= 60 then "D"
        else "F"

      $(@node).addClass(grade)
