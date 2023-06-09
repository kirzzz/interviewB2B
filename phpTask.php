<?php
/**
 * Уязвимости в исходном варианте кода:
 * Уязвимость SQL-инъекции: Если в $_GET['user_ids'] передать значение '1 OR 1=1',
 * то исходный код выполнит запрос SELECT * FROM users WHERE id=1 OR 1=1,
 * что вернет все записи из таблицы users, а не только запись с id=1
 *
 * Незащищенный доступ к данным: В исходном коде нет проверки наличия GET-параметра 'user_ids'
 * перед его использованием.
 *
 * Несколько соединений с базой данных: В исходном коде устанавливается
 * новое соединение с базой данных для каждого идентификатора пользователя в цикле foreach.
 *
 */


/**
 * Загружает данные пользователей по их идентификаторам.
 *
 * @param string $userIds Строка с идентификаторами пользователей, разделенными запятыми.
 * @return array Ассоциативный массив, где ключами являются идентификаторы пользователей,
 *               а значениями - их имена.
 */
function loadUsersData($userIds)
{
    $db = mysqli_connect("localhost", "root", "1234", "test");

    $userIds = explode(',', $userIds);
    $data = [];

    $stmt = mysqli_prepare($db, "SELECT id, name FROM users WHERE id = ?");
    mysqli_stmt_bind_param($stmt, "i", $userId);

    foreach ($userIds as $userId) {
        if (!is_numeric($userId)) {
            continue;
        }

        mysqli_stmt_execute($stmt);
        mysqli_stmt_bind_result($stmt, $id, $name);

        while (mysqli_stmt_fetch($stmt)) {
            $data[$id] = $name;
        }
    }

    mysqli_stmt_close($stmt);
    mysqli_close($db);

    return $data;
}

if (!isset($_GET['user_ids'])) {
    throw new \RuntimeException('User IDs are`t transmitted');
}

$data = loadUsersData($_GET['user_ids']);

foreach ($data as $userId => $name) {
    echo "<a href=\"/show_user.php?id=$userId\">$name</a>";
}
