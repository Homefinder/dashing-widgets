class Dashing.Codeclimate extends Dashing.Widget

  @accessor 'arrow', ->
    if @get('last')
      if parseFloat(@get('current')) > parseFloat(@get('last')) then 'icon-arrow-up' else 'icon-arrow-down'

  onData: (data) ->
    if data.status
      $(@get('node')).addClass("status-#{data.status}")