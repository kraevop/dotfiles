segmentUser() {
  local fground=$whi
  local bground=$gry
  local level=1  # '1' for top line. '2' for second.
  local enabled=true  # If false, this segment will be ignored

  #local promptSegment=" ${USER} $(date "+%I:%M %p")"
  local promptSegment=" ${USER}"
  # Output to prompt
  _parseSegments_ "${promptSegment}" "${fground}" "${bground}" "${level}" "${enabled}"
}
segmentUser