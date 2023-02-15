CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar:;.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -e 'ListExamples.java' ]]
then
    echo 'ListExamples.java found'
else
    echo 'ListExamples.java NOT found!'
    exit
fi

cp ../TestListExamples.java .
cp -r ../lib .

javac -cp $CPATH *.java > compile-output.txt 2> compile-errors.txt
if [[ $? -ne 0 ]]
then
    echo 'Compilation failed!'
    cat compile-errors.txt
    exit
else
    echo 'Compilation succeeded!'
    cat compile-output.txt
fi

if [[ -e ListExamples.class ]]
then
    echo 'ListExamples class found!'
else
    echo 'ListExamples class NOT found!'
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-output.txt 2>&1
FAILURES=`grep -l "FAILURES\!\!\!" test-output.txt`
if [[ $FAILURES == 'test-output.txt' ]]
then
    TEST_COUNT=`grep -oP "(?<=Tests run: )([0-9]+)" test-output.txt`
    FAILURE_COUNT=`grep -oP "(?<=Failures: )([0-9]+)" test-output.txt`
    echo $FAILURE_COUNT 'of' $TEST_COUNT 'tests failed.' 
else
    TEST_COUNT=`grep -oP "(?<=OK \()([0-9]+)" test-output.txt`
    echo 'All' $TEST_COUNT 'tests passed!'
fi