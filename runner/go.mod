module weberapps.com/runner

go 1.17

replace weberapps.com/day01 => ../day01

require (
	weberapps.com/day01 v0.0.0-00010101000000-000000000000
	weberapps.com/day02 v0.0.0-00010101000000-000000000000
	weberapps.com/day03 v0.0.0-00010101000000-000000000000
)

require weberapps.com/filereader v0.0.0-00010101000000-000000000000 // indirect

replace weberapps.com/day02 => ../day02

replace weberapps.com/filereader => ../filereader

replace weberapps.com/day03 => ../day03
