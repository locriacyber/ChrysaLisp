@echo off
@echo Windows > platform
@echo x86_64 > arch
@echo WIN64 > abi
@call stop.bat
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 63 -l 055-063 -l 007-063 -l 062-063 -l 056-063
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 62 -l 054-062 -l 006-062 -l 061-062 -l 062-063
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 61 -l 053-061 -l 005-061 -l 060-061 -l 061-062
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 60 -l 052-060 -l 004-060 -l 059-060 -l 060-061
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 59 -l 051-059 -l 003-059 -l 058-059 -l 059-060
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 58 -l 050-058 -l 002-058 -l 057-058 -l 058-059
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 57 -l 049-057 -l 001-057 -l 056-057 -l 057-058
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 56 -l 048-056 -l 000-056 -l 056-063 -l 056-057
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 55 -l 047-055 -l 055-063 -l 054-055 -l 048-055
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 54 -l 046-054 -l 054-062 -l 053-054 -l 054-055
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 53 -l 045-053 -l 053-061 -l 052-053 -l 053-054
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 52 -l 044-052 -l 052-060 -l 051-052 -l 052-053
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 51 -l 043-051 -l 051-059 -l 050-051 -l 051-052
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 50 -l 042-050 -l 050-058 -l 049-050 -l 050-051
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 49 -l 041-049 -l 049-057 -l 048-049 -l 049-050
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 48 -l 040-048 -l 048-056 -l 048-055 -l 048-049
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 47 -l 039-047 -l 047-055 -l 046-047 -l 040-047
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 46 -l 038-046 -l 046-054 -l 045-046 -l 046-047
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 45 -l 037-045 -l 045-053 -l 044-045 -l 045-046
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 44 -l 036-044 -l 044-052 -l 043-044 -l 044-045
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 43 -l 035-043 -l 043-051 -l 042-043 -l 043-044
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 42 -l 034-042 -l 042-050 -l 041-042 -l 042-043
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 41 -l 033-041 -l 041-049 -l 040-041 -l 041-042
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 40 -l 032-040 -l 040-048 -l 040-047 -l 040-041
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 39 -l 031-039 -l 039-047 -l 038-039 -l 032-039
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 38 -l 030-038 -l 038-046 -l 037-038 -l 038-039
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 37 -l 029-037 -l 037-045 -l 036-037 -l 037-038
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 36 -l 028-036 -l 036-044 -l 035-036 -l 036-037
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 35 -l 027-035 -l 035-043 -l 034-035 -l 035-036
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 34 -l 026-034 -l 034-042 -l 033-034 -l 034-035
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 33 -l 025-033 -l 033-041 -l 032-033 -l 033-034
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 32 -l 024-032 -l 032-040 -l 032-039 -l 032-033
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 31 -l 023-031 -l 031-039 -l 030-031 -l 024-031
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 30 -l 022-030 -l 030-038 -l 029-030 -l 030-031
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 29 -l 021-029 -l 029-037 -l 028-029 -l 029-030
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 28 -l 020-028 -l 028-036 -l 027-028 -l 028-029
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 27 -l 019-027 -l 027-035 -l 026-027 -l 027-028
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 26 -l 018-026 -l 026-034 -l 025-026 -l 026-027
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 25 -l 017-025 -l 025-033 -l 024-025 -l 025-026
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 24 -l 016-024 -l 024-032 -l 024-031 -l 024-025
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 23 -l 015-023 -l 023-031 -l 022-023 -l 016-023
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 22 -l 014-022 -l 022-030 -l 021-022 -l 022-023
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 21 -l 013-021 -l 021-029 -l 020-021 -l 021-022
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 20 -l 012-020 -l 020-028 -l 019-020 -l 020-021
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 19 -l 011-019 -l 019-027 -l 018-019 -l 019-020
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 18 -l 010-018 -l 018-026 -l 017-018 -l 018-019
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 17 -l 009-017 -l 017-025 -l 016-017 -l 017-018
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 16 -l 008-016 -l 016-024 -l 016-023 -l 016-017
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 15 -l 007-015 -l 015-023 -l 014-015 -l 008-015
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 14 -l 006-014 -l 014-022 -l 013-014 -l 014-015
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 13 -l 005-013 -l 013-021 -l 012-013 -l 013-014
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 12 -l 004-012 -l 012-020 -l 011-012 -l 012-013
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 11 -l 003-011 -l 011-019 -l 010-011 -l 011-012
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 10 -l 002-010 -l 010-018 -l 009-010 -l 010-011
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 9 -l 001-009 -l 009-017 -l 008-009 -l 009-010
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 8 -l 000-008 -l 008-016 -l 008-015 -l 008-009
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 7 -l 007-063 -l 007-015 -l 006-007 -l 000-007
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 6 -l 006-062 -l 006-014 -l 005-006 -l 006-007
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 5 -l 005-061 -l 005-013 -l 004-005 -l 005-006
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 4 -l 004-060 -l 004-012 -l 003-004 -l 004-005
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 3 -l 003-059 -l 003-011 -l 002-003 -l 003-004
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 2 -l 002-058 -l 002-010 -l 001-002 -l 002-003
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 1 -l 001-057 -l 001-009 -l 000-001 -l 001-002
@start /b .\obj\x86_64\WIN64\Windows\main.exe .\obj\x86_64\WIN64\sys\boot_image -cpu 0 -l 000-056 -l 000-008 -l 000-007 -l 000-001 -run gui/gui/gui.lisp