# GitHub Score [![Build Status](https://travis-ci.org/leonardorb/github_score.svg?branch=master)](https://travis-ci.org/leonardorb/github_score)
What's your GitHub score?

Current formula: `((C*1)+(LS*3.5)+(CS*7.25))*((C/Y)*((F*0.0015)+1))`, where:

`C` = Contributions

`LS` = Longest Streak

`CS` = Current Streak

`Y` = Year Period in Days (365)

`F` = Followers

## How to use it

### Install dependencies

    $ npm install -g gulp
    $ npm install

### Run gulp

    $ gulp

### Get your score!

    $ node src/assets/js/score.js leonardorb hugw tspaulino suissa zenorocha ebidel


![](http://d.pr/i/1czee+)


## Running Tests

### Run the tests!

    $ npm test

## Contributors

- Leo ([github](https://github.com/leonardorb)) ([twitter](https://twitter.com/leonardorb))
- Daniel ([github](https://github.com/dpsxp)) ([twitter](https://twitter.com/dpsxp))

## How to Contribute
- Before you open a ticket or send a pull request, `search` for previous discussions about the same feature or issue. Add to the earlier ticket if you find one.
- Before sending a pull request for a feature or bug fix, be sure to have `tests`.
- Use the same `coding style` as the rest of the codebase.
- All pull requests should be made to the `master` branch.

## License

**The MIT License (MIT)**

Copyright (c) **2015** Leonardo R. Barbosa - [rb.leonardo@gmail.com](mailto:rb.leonardo@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
