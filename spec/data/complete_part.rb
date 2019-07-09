part {
    title 'Part #7'
    tempo 120

    clip {
        label 'c1'
        event {
            note 'a'
            duration 'minim'
            dynamic 'ff'
        }
    }
    clip {
        label 'c2'
        event {
            note 'b'
            duration 'semiquaver'
            dynamic 'p'
        }
    }

    # transitions from x -> * sum to 1
    transition {
        from 'c1'
        to 'c1'
        probability 0.4
    }
    transition {
        from 'c1'
        to 'c2'
        probability 0.6
    }

    transition {
        from 'c2'
        to 'c2'
        probability 0
    }
    transition {
        from 'c2'
        to 'c1'
        probability 1
    }
}