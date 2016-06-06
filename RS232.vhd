library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS232 is
    Port ( CLK : in  STD_LOGIC;
           DATOS : in  STD_LOGIC_VECTOR (11 downto 0);
           ENVIAR : in  STD_LOGIC;
			  RX : in  STD_LOGIC;
           DATOS_ENVIADOS : out  STD_LOGIC_VECTOR (11 downto 0);
           RECIBIDO : out  STD_LOGIC;
           TX : out  STD_LOGIC);
end RS232;

architecture Behavioral of RS232 is

COMPONENT Receptor
	PORT(
		clk : IN std_logic;
		Line : IN std_logic;
		div : IN std_logic;  
		Data : OUT std_logic_vector(11 downto 0);
		receive : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT Transmisor
	PORT(
		clk : IN std_logic;
		div : IN std_logic;
		data : IN std_logic_vector(11 downto 0);
		send : IN std_logic;          
		Line : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT Div_F
	PORT(
		CLK : IN std_logic;          
		D_UART : OUT std_logic
		);
	END COMPONENT;
	
signal div_aux:STD_LOGIC;

begin


	Inst_Div_F: Div_F PORT MAP(
		clk => CLK,
		D_UART => div_aux
	);


Inst_Receptor: Receptor PORT MAP(
		clk => CLK,
		Line => RX,
		div => div_aux,
		Data => DATOS_ENVIADOS,
		receive => RECIBIDO
	);
	
Inst_Transmisor: Transmisor PORT MAP(
		clk => CLK,
		div=> div_aux,
		data => DATOS,
		send => ENVIAR,
		Line => TX
	);		



end Behavioral;
