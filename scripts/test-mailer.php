<?php

error_reporting(E_ALL ^ E_WARNING); 

class Skel {

    private $Args = null;
    private $Mode = null;

    protected function mode ($str = null) {
        if (isset($str)) {
            $this->Mode = $str;
        }
        else {
            return $this->Mode;
        }
    }

    protected function args ($str = null) {
        if (is_array($str)) {
            if ($this->Mode == 'cli') {
                array_shift($str);
                foreach ($str as $val) {
                    if (preg_match('/^([^=]+)[=](.+)$/', $val, $match)) {
                        $this->Args[$match['1']] = $match['2'];
                    }
                }
            }
            if ($this->Mode == 'web') {
                foreach ($str as $key => $val) {
                    $this->Args[$key] = $val;
                }                   
            }
        }
        else {
            return $this->Args;
        }
    }

}

class Verbose extends Skel {
    
    private $Message = null;

    private function wrap ($str) {
        if ($this->mode() == 'web') {
            $str = preg_replace('/(?:\[\s)([^\]]+)(?:\s\])/',
                                    '[ <b>${1}</b> ]', $str);
            $str = "<p>$str</p>";
        }
        else {
            $str = "$str\n";
        }
        return $str;
    }

    protected function verbose ($arr = null) {
        if (is_array($arr)) {
            $this->Message = null;
            foreach ($arr as $line) {
                $this->Message .= $this->wrap($line);
            }
        }
        else {
            return $this->Message;
        }
    }
}

class MailerProperties extends Verbose {

    private $Properties = array(
        'from'     => null,
        'to'       => null,
        'reply'    => null,
        'subject'  => "Test Email",
        'message'  => "This is an email sent for testing purposes.\nPlease disregard\n",
        'headers'  => null,
    );

    protected function property ($action, $name, $value = null) {
        if ($action == 'get') {
            return (isset($this->Properties[$name]))
                    ? $this->Properties[$name]
                    : false
                    ;
        }        
        if ($action == 'set') {
            $this->Properties[$name] = $value;
        }
        if ($action == 'add') {
            $this->Properties[$name] .= $value;
        }
    }

}

class Validator extends MailerProperties {

    private $email  = '/^(?:[\w.-]+?@[\w-]+[.][\w-]{2,24}(?:[.]\w+)*)$/';
    private $params = '/^(?:from|to)$/';

    protected function validate () {

        foreach ($this->args() as $key => $val) {
            if (!preg_match($this->params, $key)) {
                $this->verbose(array(
                    "Invalid parameter passed: [ $key ]",
                    "The valid parameters are: [ from, to ]",
                ));
                die($this->verbose());           
            }
            if (!preg_match($this->email, $val)) {
                $this->verbose(array(
                    "Invalid email address: [ $val ]",
                ));
                die($this->verbose());
            }
            $this->property('set', $key, $val);
        }

    }

}

class Sender extends Validator {

    private function _send () {
        $result = (mail($this->property('get', 'to'),
                        $this->property('get', 'subject'),
                        $this->property('get', 'message'),
                        $this->property('get', 'headers')))
                ? array("Success: [ the email has been successfully sent! ]")
                : array("Failure: [ the email was not sent! ]")
                ;
        $this->verbose($result);
        die($this->verbose());
    }

   private function _check_properties () {
        if (!$this->property('get', 'from')) {
            $this->verbose(array(
                "Missing parameter: [ from ]",
                "Cannot send email without a sender!",
            ));
            die($this->verbose());
        }
        if (!$this->property('get', 'to')) {
            $this->verbose(array(
                "Missing parameter: [ to ]",
                "Cannot send email without a recipient!",
            ));
            die($this->verbose());
        }

        $this->property('set', 'headers',
                            "From: "
                            . $this->property('get', 'from') . "\r\n"); 

        if ($this->property('get', 'reply')) {
            $this->property('add', 'headers',
                                "Reply-to: "
                                . $this->property('get', 'reply') . "\r\n");
        }

        $this->verbose(array("Mode: " . $this->mode(),
                                "Sending a test email from [ "
                                . $this->property('get', 'from') . " ]"
                                . " to [ "
                                . $this->property('get', 'to') . " ]",
                                "Subject is [ "
                                . $this->property('get', 'subject') . " ]"));

        echo $this->verbose();
        $this->_send();
    }

    protected function send () {
        if ($this->mode() == 'web') {   
             echo  '<form action="' . $_SERVER['PHP_SELF'] . '">'
            . '<p>From: <input type="text" name="from" value=""></p>'
            . '<p>To: <input type="text" name="to" value=""></p>'
            . '<input type="submit" value="Send">'
            . '</form>';    
        }
        $this->validate();
        $this->_check_properties();
    }

}

class Initializer extends Sender {
    protected function init ($arr = array()) {
        $this->mode($arr['0']);
        $this->args($arr['1']);
        $this->send();
    }
}

class Mailer extends Initializer {
    public function __construct ($arr = array()) {
        $this->init($arr);
    }    
}

$ENV  = (isset($_SERVER['TERM']))
      ? array('cli', $argv)
      : array('web', (empty($_POST)) ? $_GET : $_POST)
      ;

new Mailer($ENV);

?>
