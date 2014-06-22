file 	{	
	'/tmp/test4':
	ensure		=> 	file,
	mode		=>	0640,
	content		=>	"Test Message with update",
}

notify	{
	'subscribed':
	message		=>	"Test4 has been updated",
	subscribe	=>	File['/tmp/test4'],
}

