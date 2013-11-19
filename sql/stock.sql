DROP TABLE tradingLimit;

CREATE TABLE tradingLimit (

tradedate DATE,

amount varchar(12),
buy varchar(8),
changepercent char(6),
code char(6),
high varchar(8),
low varchar(8),
/*总市值*/
mktcap float(14, 5),
name char(8),
/*流通市值*/
nmc float(14, 5),
open varchar(8),
/* 市净率 */
/*pb*/
/* 未知 */
/*per*/
pricechange varchar(7),
sell varchar(8),
settlement varchar(8),
symbol char(8),
ticktime char(8),
trade varchar(8),
/* 换手率 */
turnoverratio float(7, 5),
volume varchar(12)
)ENGINE=MyISAM DEFAULT CHARSET=utf8;