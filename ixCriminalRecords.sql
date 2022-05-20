--
-- Structure de la table `criminal_records`
--

CREATE TABLE `criminal_records` (
  `depositary` varchar(40) NOT NULL,
  `name` varchar(40) NOT NULL,
  `age` varchar(10) NOT NULL,
  `height` varchar(10) NOT NULL,
  `nationality` varchar(25) NOT NULL,
  `sex` varchar(10) NOT NULL,
  `date` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Structure de la table `criminal_records_content`
--

CREATE TABLE `criminal_records_content` (
  `depositary` varchar(40) NOT NULL,
  `name` varchar(40) NOT NULL,
  `motif` varchar(200) NOT NULL,
  `date` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




ALTER TABLE `criminal_records`
  ADD PRIMARY KEY (`name`);
COMMIT;


