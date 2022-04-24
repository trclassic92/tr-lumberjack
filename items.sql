
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
   ('tree_lumber', 'tree_lumber', 1, 0, 1),
  ('tree_bark', 'tree_bark', 1, 0, 1),
  ('wood_plank ', 'wood_plank ', 1, 0, 1);


INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
  (1000, 'lumberjack', 0, 'lumberjack', 'Worker', 0, '', '');


INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
      ('lumberjack', 'Lumberjack', 1);
