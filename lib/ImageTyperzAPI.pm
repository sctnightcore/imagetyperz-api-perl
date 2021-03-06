#!/bin/perl

package ImageTyperzAPI;

use warnings;
use strict;
use LWP::UserAgent;
use HTTP::Request::Common;
use MIME::Base64 qw(encode_base64);
use URI qw( );

# constants
# --------------------------------------------------------------------------------------------
my $CAPTCHA_ENDPOINT = 'http://captchatypers.com/Forms/UploadFileAndGetTextNEW.ashx';
my $RECAPTCHA_SUBMIT_ENDPOINT = 'http://captchatypers.com/captchaapi/UploadRecaptchaV1.ashx';
my $RECAPTCHA_RETRIEVE_ENDPOINT = 'http://captchatypers.com/captchaapi/GetRecaptchaText.ashx';
my $BALANCE_ENDPOINT = 'http://captchatypers.com/Forms/RequestBalance.ashx';
my $BAD_IMAGE_ENDPOINT = 'http://captchatypers.com/Forms/SetBadImage.ashx';
my $PROXY_CHECK_ENDPOINT = 'http://captchatypers.com/captchaAPI/GetReCaptchaTextJSON.ashx';
my $GEETEST_SUBMIT_ENDPOINT = 'http://captchatypers.com/captchaapi/UploadGeeTest.ashx';
my $GEETEST_RETRIEVE_ENDPOINT = 'http://captchatypers.com/captchaapi/getrecaptchatext.ashx';

my $CAPTCHA_ENDPOINT_CONTENT_TOKEN = 'http://captchatypers.com/Forms/UploadFileAndGetTextNEWToken.ashx';
my $CAPTCHA_ENDPOINT_URL_TOKEN = 'http://captchatypers.com/Forms/FileUploadAndGetTextCaptchaURLToken.ashx';
my $RECAPTCHA_SUBMIT_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaapi/UploadRecaptchaToken.ashx';
my $RECAPTCHA_RETRIEVE_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaapi/GetRecaptchaTextToken.ashx';
my $BALANCE_ENDPOINT_TOKEN = 'http://captchatypers.com/Forms/RequestBalanceToken.ashx';
my $BAD_IMAGE_ENDPOINT_TOKEN = 'http://captchatypers.com/Forms/SetBadImageToken.ashx';
my $PROXY_CHECK_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaAPI/GetReCaptchaTextTokenJSON.ashx';
my $GEETEST_SUBMIT_ENDPOINT_TOKEN = 'http://captchatypers.com/captchaapi/UploadGeeTestToken.ashx';

# ACCESS TOKEN
# --------------
# Solve normal captcha
# --------------------------------------------------
sub solve_captcha_token
{
	my $ref_id = '0';
	my $iscase = '';
	my $isphrase = '';
	my $ismath = '';
	my $alphanumeric = '0';
	my $minlength = '';
	my $maxlength = '';
	
	my $ua = LWP::UserAgent->new();
	# case
	if(defined $_[2])		# check if chkcase was given
	{
		$iscase = $_[2];	# set chkcase
	}
	# phrase
	if(defined $_[3])
	{
		$isphrase = $_[3];
	}
	# math
	if(defined $_[4])
	{
		$ismath = $_[4];
	}
	# alphanumeric
	if(defined $_[5])
	{
		$alphanumeric = $_[5];
	}
	# minlength
	if(defined $_[6])
	{
		$minlength = $_[6];
	}
	# maxlength
	if(defined $_[7])
	{
		$maxlength = $_[7];
	}
	# maxlength
	if(defined $_[8])
	{
		$ref_id = $_[8];
	}

	# read file
    local $/ = undef;
    open FILE, $_[1] or die "Couldn't open file: $!";
    my $string = <FILE>;
    close FILE;

	my $response = $ua->request(POST $CAPTCHA_ENDPOINT_CONTENT_TOKEN, Content => [
				 action => 'UPLOADCAPTCHA',
				 token => $_[0],
				 file => encode_base64($string),
				 iscase => $iscase,
				 isphrase => $isphrase,
				 ismath => $ismath,
				 alphanumeric => $alphanumeric,
		   		 minlength => $minlength,
				 maxlength => $maxlength,
				 affiliateid => $ref_id
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
		return replace("Uploading file...", "", $c);
    }
}


# LEGACY WAY
# this might get deprecated, better of using access_token
# --------------------------------------------------------

# Solve normal captcha
# --------------------------------------------------
sub solve_captcha_legacy
{
	my $ref_id = '0';
	my $iscase = '';
	my $isphrase = '';
	my $ismath = '';
	my $alphanumeric = '0';
	my $minlength = '';
	my $maxlength = '';

	my $ua = LWP::UserAgent->new();
	# case
	if(defined $_[3])		# check if chkcase was given
	{
		$iscase = $_[3];	# set chkcase
	}
	# phrase
	if(defined $_[4])
	{
		$isphrase = $_[4];
	}
	# math
	if(defined $_[5])
	{
		$ismath = $_[5];
	}
	# alphanumeric
	if(defined $_[6])
	{
		$alphanumeric = $_[6];
	}
	# minlength
	if(defined $_[7])
	{
		$minlength = $_[7];
	}
	# maxlength
	if(defined $_[8])
	{
		$maxlength = $_[8];
	}
	# maxlength
	if(defined $_[9])
	{
		$ref_id = $_[9];
	}

	# read file
	local $/ = undef;
	open FILE, $_[2] or die "Couldn't open file: $!";
	my $string = <FILE>;
	close FILE;

	my $response = $ua->request(POST $CAPTCHA_ENDPOINT, Content => [
		action => 'UPLOADCAPTCHA',
		username => $_[0],
		password => $_[1],
		file => encode_base64($string),
		iscase => $iscase,
		isphrase => $isphrase,
		ismath => $ismath,
		alphanumeric => $alphanumeric,
		minlength => $minlength,
		maxlength => $maxlength,
		affiliateid => $ref_id
	]);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		}
		return replace("Uploading file...", "", $c);
	}
}


# Submit recaptcha
# -------------------------------------------------------------------------------------------------
sub submit_recaptcha_token
{
	my $ua = LWP::UserAgent->new();
	my $data = $_[0];
	
	my $response = $ua->request(POST $RECAPTCHA_SUBMIT_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => $data);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		# return ID
    }
}

# Retrieve recaptcha
# -------------------------------------------------------------------------------------------------
sub retrieve_recaptcha_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $RECAPTCHA_RETRIEVE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'GETTEXT',
				 token => $_[0],
				 captchaid => $_[1],
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			if (index($c, 'NOT_DECODED') != -1) {		
				 return $c;		# return NOT_DECODED
			}
			else  {die($c);}	# error, die
		} 
        return $c;		# return ID	
    }
}

# Checks if recaptcha is still in process of solving
sub in_progress_token
{
	my $resp = retrieve_recaptcha_token($_[0], $_[1]);
	if(index($resp, 'NOT_DECODED') == -1)
	{
		return 0;		# does not contain NOT_DECODED, move on
	}
	else
	{
		return 1;		# contains NOT_DECODED, still in progress
	}
}

# Checks if geetest is still in process of solving
sub in_progress_geetest
{
	my $resp = retrieve_geetest($_[0]);
	if(index($resp, 'NOT_DECODED') == -1)
	{
		return 0;		# does not contain NOT_DECODED, move on
	}
	else
	{
		return 1;		# contains NOT_DECODED, still in progress
	}
}

# Submit geetest
sub submit_geetest_token
{
	my $ua = LWP::UserAgent->new();
	my $data = $_[0];

	my $url = $GEETEST_SUBMIT_ENDPOINT_TOKEN;
	$url .= '?';
	my $u = URI->new('', 'http');
	$u->query_form(@$data);
	my $query = $u->query;
	$url .= $query;
	my $response = $ua->request(GET $url);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		}
		return $c;		# return ID
	}
}

# Check account balance
# -------------------------------------------------------------------------------------------------
sub account_balance_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BALANCE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'REQUESTBALANCE',
				 token => $_[0],
				 'submit' => 'Submit'
				]);

    if ($response->is_error())
    {
		return $response->status_line;			# return error
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return '$' . $c;		# return balance
    }
}

# Set captcha as BAD
sub set_captcha_bad_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BAD_IMAGE_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
				 action => 'SETBADIMAGE',
				 token => $_[0],
				 imageid =>$_[1],
				 submit => "Submissssst"
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
        my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		
    }
}

# Tells if proxy was used, and if not reason why - token
sub was_proxy_used_token
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $PROXY_CHECK_ENDPOINT_TOKEN, Content_Type => 'form-data', Content => [
		action => 'GETTEXT',
		token => $_[0],
		captchaid =>$_[1],
	]);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'Error') != -1) {
			die($c);
		}
		return $c;
	}
}

# Tells if proxy was used, and if not reason why - legacy
sub was_proxy_used_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $PROXY_CHECK_ENDPOINT, Content_Type => 'form-data', Content => [
		action => 'GETTEXT',
		username => $_[0],
		password => $_[1],
		captchaid =>$_[2],
	]);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'Error') != -1) {
			die($c);
		}
		return $c;
	}
}

# Submit recaptcha
# -------------------------------------------------------------------------------------------------
sub submit_recaptcha_legacy
{
	my $ua = LWP::UserAgent->new();
	my $data = $_[0];

	my $response = $ua->request(POST $RECAPTCHA_SUBMIT_ENDPOINT, Content_Type => 'form-data', Content => $data);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		}
		return $c;		# return ID
	}
}

# Retrieve recaptcha
# -------------------------------------------------------------------------------------------------
sub retrieve_recaptcha_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $RECAPTCHA_RETRIEVE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'GETTEXT',
				 username => $_[0],
				 password => $_[1],
				 captchaid => $_[2],
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			if (index($c, 'NOT_DECODED') != -1) {		
				 return $c;		# return NOT_DECODED
			}
			else {die($c);}	# error, die
		} 
        return $c;		# return ID	
    }
}

# Retrieve recaptcha
# -------------------------------------------------------------------------------------------------
sub retrieve_geetest
{
	my $data = $_[0];
	my $ua = LWP::UserAgent->new();
	my $url = $GEETEST_RETRIEVE_ENDPOINT;
	$url .= '?';
	my $u = URI->new('', 'http');
	$u->query_form(@$data);
	my $query = $u->query;
	$url .= $query;
	my $response = $ua->request(GET $url);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			if (index($c, 'NOT_DECODED') != -1) {
				return $c;		# return NOT_DECODED
			}
			else {die($c);}	# error, die
		}
		return $c;		# return ID
	}
}

# Checks if recaptcha is still in process of solving
sub in_progress_legacy
{
	my $resp = retrieve_recaptcha_legacy($_[0], $_[1], $_[2]);
	if(index($resp, 'NOT_DECODED') == -1)
	{
		return 0;		# does not contain NOT_DECODED, move on
	}
	else
	{
		return 1;		# contains NOT_DECODED, still in progress
	}
}

# Submit geetest
sub submit_geetest_legacy
{
	my $ua = LWP::UserAgent->new();
	my $data = $_[0];

	my $url = $GEETEST_SUBMIT_ENDPOINT;
	$url .= '?';
	my $u = URI->new('', 'http');
	$u->query_form(@$data);
	my $query = $u->query;
	$url .= $query;
	my $response = $ua->request(GET $url);

	if ($response->is_error())
	{
		return $response->status_line;
	} else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		}
		return $c;		# return ID
	}
}

# Check account balance
# -------------------------------------------------------------------------------------------------
sub account_balance_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BALANCE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'REQUESTBALANCE',
				 username => $_[0],
				 password => $_[1],
				 'submit' => 'Submit'
				]);

    if ($response->is_error())
    {
		return $response->status_line;			# return error
    } else {
		my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return '$' . $c;	
    }
}

# Set captcha as BAD
sub set_captcha_bad_legacy
{
	my $ua = LWP::UserAgent->new();
	my $response = $ua->request(POST $BAD_IMAGE_ENDPOINT, Content_Type => 'form-data', Content => [
				 action => 'SETBADIMAGE',
				 username => $_[0],
				 password => $_[1],
				 imageid =>$_[2],
				 submit => "Submissssst"
				]);

   	if ($response->is_error())
   	{
		return $response->status_line;
    } else {
        my $c = $response->content();
		if (index($c, 'ERROR') != -1) {
			die($c);
		} 
        return $c;		
    }
}

# replace string
sub replace {
	  my ($from,$to,$string) = @_;
	  $string =~s/$from/$to/ig;                          #case-insensitive/global (all occurrences)

	  return $string;
}

1;
