library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receptor is
    Port ( Line : in  STD_LOGIC; --lo que le entra, recibe de a bit
           div : in  STD_LOGIC; --divisor de frecuencia 
			  clk : in  STD_LOGIC; --reloj de la FPGA
			  Data : out  STD_LOGIC_VECTOR (11 downto 0); --datos recibidos en registro
			  receive : out STD_LOGIC 
			  );
end Receptor;

architecture Behavioral of Receptor is


signal estado : STD_LOGIC_VECTOR (4 downto 0):="00000"; --inicio,datos a recibir, parada --12 estados
signal registro : STD_LOGIC_VECTOR (11 downto 0):="000000000000";--bits de datos que se reciben
signal receive_aux: STD_LOGIC := '0';--este es el que controla, si es en 1 entonces ya recibió todos los datos


begin
 
process(Line, div,estado,registro,receive_aux,clk)
begin

if(rising_edge(clk)) then
	receive_aux<='0'; --conserva en 0 hasta que se termina de llenar
	if (div ='1') then --divisor de frecuencia
	case estado is
	   
		when 	"00000" => if (Line='0')  then --bit de inicio
									estado<="00001";--siguiente estado
									end if;
									
		when 	"00001" => if (Line='0' or Line='1')  then	--Estado 1 --primer bit de dato
									estado<="00010";
									registro(11) <=Line; --decrementa el tamaño del vector y le concatena el bit que traiga line 							
									end if;
		
		when 	"00010" => if (Line='0' or Line='1')  then	--Estado 2
									estado<="00011";
									registro(10) <=Line;							
									end if;
		
		when 	"00011" => if (Line='0' or Line='1')  then	--Estado 3
									estado<="00100";
									registro(9) <=Line;							
									end if;
		
		when 	"00100" => if (Line='0' or Line='1')  then	--Estado 4
									estado<="00101";
									registro(8) <=Line;						
									end if;
								
		
		when 	"00101" => if (Line='0' or Line='1')  then	--Estado 5
									estado<="00110";
									registro(7) <=Line;						
									end if;
									
	   when 	"00110" => if (Line='0' or Line='1')  then	--Estado 6
									estado<="00111";
									registro(6) <=Line;						
									end if;
	   
		when 	"00111" => if (Line='0' or Line='1')  then	--Estado 7
									estado<="01000";
									registro(5) <=Line;						
									end if;
									
		when "01000" => if (Line='0' or Line='1')  then		--Estado 8
									estado<="01001";				
									registro(4) <=Line;						
									end if;
									
		when "01001" => if (Line='0' or Line='1')  then		--Estado 9
									estado<="01010";				
									registro(3) <=Line;						
									end if;
									
		when "01010" => if (Line='0' or Line='1')  then		--Estado 10
									estado<="01011";				
									registro(2) <=Line;						
									end if;
									
		when "01011" => if (Line='0' or Line='1')  then		--Estado 11
									estado<="01100";				
									registro(1) <=Line;						
									end if;
									
		when "01100" => if (Line='0' or Line='1')  then		--Estado 12, Retorna a Idle
									estado<="01101";				
									registro(0) <=Line;						
									end if;
									
		when "01101" => if(Line='1') then --bit de parada
							receive_aux<='1';
							end if;
							estado<="00000";--vuelve al estado inicial
							
		when OTHERS => estado <= "00000";
		
		end case;
	end if;
end if;
data<=registro;
receive <= receive_aux;	--cuando receive_aux=1 significa que llegó al bit de parada
end process;	
																		
end Behavioral;
