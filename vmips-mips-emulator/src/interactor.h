
#ifndef INTERACTOR_H
#define INTERACTOR_H

class Interactor {
public:
    virtual void interact() = 0;
    virtual void stop_interacting() = 0;
    virtual ~Interactor() { }
};

Interactor *create_interactor();

#endif /* INTERACTOR_H */
