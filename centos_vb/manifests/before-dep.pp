file	{ 
	'/tmp/test1':
	ensure 		=>	present,
	content		=>	"Hi.",
	before		=>	Notify['test'],
}

notify	{
	'test':
	message		=>	"Well hello, the file /tmp/test1 has already been created",
}
