<?php
/**
 * Riceve i dati del form contatti via POST (fetch/AJAX) e invia una email.
 * Risponde sempre in JSON: { success: bool, message: string }
 */

header('Content-Type: application/json; charset=utf-8');

// Solo POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodo non consentito.']);
    exit;
}

// --- Configurazione ---
$destinatario = 'info@tacun.it';
$mittenteSito = 'noreply@tacun.it'; // deve essere una casella sul dominio che invia (per SPF/deliverability)

// --- Honeypot anti-spam: se il campo nascosto è compilato, è un bot ---
if (!empty($_POST['sito-web'])) {
    // Rispondiamo "successo" per non dare indizi ai bot, ma non inviamo nulla
    echo json_encode(['success' => true, 'message' => 'Richiesta inviata.']);
    exit;
}

// --- Funzione di sanitizzazione base contro header injection ---
function pulisci($valore) {
    $valore = trim($valore);
    $valore = str_replace(["\r", "\n"], '', $valore);
    return $valore;
}

// --- Recupero e validazione campi obbligatori ---
$nome      = isset($_POST['nome'])      ? pulisci($_POST['nome'])      : '';
$cognome   = isset($_POST['cognome'])   ? pulisci($_POST['cognome'])   : '';
$email     = isset($_POST['email'])     ? pulisci($_POST['email'])     : '';
$azienda   = isset($_POST['azienda'])   ? pulisci($_POST['azienda'])   : '';
$messaggio = isset($_POST['messaggio']) ? trim($_POST['messaggio'])    : '';
$richiesta = isset($_POST['richiesta']) ? pulisci($_POST['richiesta']) : '';
$privacy   = isset($_POST['privacy']);

$errori = [];

if ($nome === '')    $errori[] = 'nome';
if ($cognome === '') $errori[] = 'cognome';
if ($azienda === '') $errori[] = 'azienda';
if (!$privacy)        $errori[] = 'privacy';
if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errori[] = 'email';
}

if (!empty($errori)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Alcuni campi obbligatori mancano o non sono validi.'
    ]);
    exit;
}

// --- Oggetto: usa la card selezionata, se presente ---
$oggetto = $richiesta !== ''
    ? 'Richiesta di contatto - ' . $richiesta
    : 'Richiesta di contatto dal sito';

// --- Corpo del messaggio ---
$corpo  = "Nuova richiesta dal form contatti del sito:\n\n";
$corpo .= "Nome: {$nome} {$cognome}\n";
$corpo .= "Email: {$email}\n";
$corpo .= "Azienda: {$azienda}\n";
if ($richiesta !== '') {
    $corpo .= "Richiesta: {$richiesta}\n";
}
$corpo .= "\nMessaggio:\n" . ($messaggio !== '' ? $messaggio : '(nessun messaggio)') . "\n";

// --- Header email ---
$headers   = [];
$headers[] = 'From: ' . $mittenteSito;
$headers[] = 'Reply-To: ' . $email;
$headers[] = 'Content-Type: text/plain; charset=UTF-8';
$headers[] = 'X-Mailer: PHP/' . phpversion();

$oggettoCodificato = '=?UTF-8?B?' . base64_encode($oggetto) . '?=';

$inviata = mail(
    $destinatario,
    $oggettoCodificato,
    $corpo,
    implode("\r\n", $headers)
);

if ($inviata) {
    echo json_encode(['success' => true, 'message' => 'Richiesta inviata correttamente.']);
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errore durante l\'invio. Riprova più tardi.']);
}
