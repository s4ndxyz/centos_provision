<?php

$API_TOKEN = getopt('HZ_API_KEY');
$SERVER_ID = getopt('HZ_SERVER_ID');
$IMAGE = 'centos-7';
$MAX_ATTEMPTS = 2;

try {
    echo "Reinstalling server" . PHP_EOL;

    $result = request('POST', "/servers/${SERVER_ID}/actions/rebuild", [
        'image' => $IMAGE,
    ]);

    echo "Waiting until it's ready" . PHP_EOL;

    $ready = false;
    $attempts = 0;
    do {
        $result = request('GET', "/servers/${SERVER_ID}");
        if ($result->server->status == 'running') {
            echo "Server is ready" . PHP_EOL;
            $ready = true;
        } else {
            sleep(2);
            echo 'Status: ' . $result->server->status . PHP_EOL;
            $attempts++;
            if ($attempts > $MAX_ATTEMPTS) {
                throw new \Exception('Exceeds max attempts ' . $MAX_ATTEMPTS);
            }

        }
    } while (!$ready);

    echo 'Installing Keitaro ' . PHP_EOL;
} catch (\Exception $exception) {
    echo $exception . PHP_EOL;
    echo $exception->getTraceAsString() . PHP_EOL;
    exit(1);
}

function request($method, $path, $data = []) {
    global $API_TOKEN;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://api.hetzner.cloud/v1' . $path);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $API_TOKEN
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    if ($method == 'POST') {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }

    $output = curl_exec($ch);

    $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if ($httpcode > 300) {
        throw new \Exception('Response error ' . $httpcode . ': ' . $output);
    }

    if (curl_error($ch)) {
        throw new \Exception(curl_error($ch));
    }
    curl_close($ch);
    $result = json_decode($output);
    if (empty($result)) {
        throw new \Exception('Incorrect response: ' . $output);
    }
    return $result;
}