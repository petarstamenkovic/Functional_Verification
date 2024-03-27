library ieee;
use ieee.std_logic_1164.all;

package utils_pkg is
    function log2c (n: integer) return integer;
end utils_pkg;

package body utils_pkg is
    function log2c (n: integer) return integer is
        variable m, p: integer;
    begin
        m := 0;
        p := 1;
        while p < n loop
            m := m + 1;
            p := p * 2;
        end loop;
        return m;
    end log2c;
end utils_pkg;